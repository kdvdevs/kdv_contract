ESX = exports['es_extended']:getSharedObject()

local function _L(key, ...)
    local locale = Config.Locale or 'en'
    local str = Config.Locales[locale][key] or key
    return string.format(str, ...)
end

Citizen.CreateThread(function()
    local success = pcall(MySQL.scalar.await, "SELECT `transfer_count` FROM owned_vehicles LIMIT 1")
    if not success then
        local defaultValue = Config.DefaultTransferCount or 0
        MySQL.query(string.format([[
            ALTER TABLE `owned_vehicles`
            ADD COLUMN `transfer_count` INT DEFAULT %d
        ]], defaultValue))
    end
end)

local function isOwner(identifier, plate)
    local checkPlate = string.upper(string.gsub(plate, "%s+", ""))
    local result = MySQL.Sync.fetchAll(
        'SELECT * FROM owned_vehicles WHERE owner = @identifier AND REPLACE(UPPER(plate), " ", "") = @plate',
        {
            ['@identifier'] = identifier,
            ['@plate'] = checkPlate
        }
    )
    return result[1] ~= nil
end

function SendDiscordLog(title, description)
    if not Config.DiscordLog or not Config.DiscordLog.Enable then return end
    local webhook = Config.DiscordLog.Webhook
    if not webhook or webhook == "" then return end

    PerformHttpRequest(webhook, function() end, "POST", json.encode({
        username = "Contract Log",
        embeds = {{
            title = title,
            description = description,
            color = 65280,
            footer = { text = os.date("%Y-%m-%d %H:%M:%S") }
        }}
    }), { ["Content-Type"] = "application/json" })
end

RegisterServerEvent('contract:sellVehicle')
AddEventHandler('contract:sellVehicle', function(sellerId, buyerId, plate, price, transferCount)
    local xPlayer = ESX.GetPlayerFromId(sellerId)
    local tPlayer = ESX.GetPlayerFromId(buyerId)

    MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
        ['@owner'] = xPlayer.identifier,
        ['@plate'] = plate,
        ['@target'] = tPlayer.identifier
    }, function (rowsChanged)
        if rowsChanged ~= 0 then
            local transferCountLog = "N/A"
            if Config.UseTransferCount then
                MySQL.Sync.execute('UPDATE owned_vehicles SET transfer_count = GREATEST(transfer_count - 1, 0) WHERE plate = @plate', {
                    ['@plate'] = plate
                })
                local result = MySQL.Sync.fetchAll('SELECT transfer_count FROM owned_vehicles WHERE plate = @plate', {
                    ['@plate'] = plate
                })
                if result[1] and result[1].transfer_count ~= nil then
                    transferCountLog = tostring(result[1].transfer_count)
                end
            end

            if Config.Contract.UseAnim then
                TriggerClientEvent('contract:showAnim', sellerId)
                Wait(22000)
            end
            if Config.Contract.UseAnim then
                TriggerClientEvent('contract:showAnim', buyerId)
                Wait(22000)
            end
            tPlayer.removeMoney(price)
            xPlayer.addMoney(price)
            TriggerClientEvent('esx:showNotification', sellerId, _L('soldvehicle', plate, price))
            TriggerClientEvent('esx:showNotification', buyerId, _L('boughtvehicle', plate, price))
            xPlayer.removeInventoryItem('contract', 1)

            SendDiscordLog(
                "Vehicle Contract Transaction",
                string.format(
                    "Seller: **%s** (ID: %s)\nBuyer: **%s** (ID: %s)\nVehicle: **%s** - Plate: **%s**\nPrice: **$%s**\nTransfer Count: **%s**",
                    xPlayer.getName(), sellerId, tPlayer.getName(), buyerId, plate, plate, price, transferCountLog
                )
            )
        end
    end)
end)

ESX.RegisterUsableItem('contract', function(source)
    TriggerClientEvent('contract:getVehicle', source)
end)

RegisterNetEvent('contract:sendOffer')
AddEventHandler('contract:sendOffer', function(buyerId, price, plate, model)
    local sellerId = source
    local tPlayer = ESX.GetPlayerFromId(buyerId)
    local xPlayer = ESX.GetPlayerFromId(sellerId)

    if not isOwner(xPlayer.identifier, plate) then
        TriggerClientEvent('esx:showNotification', sellerId, _L('notyourcar'))
        return
    end

    if not tPlayer then
        TriggerClientEvent('esx:showNotification', sellerId, _L('playeroffline'))
        return
    end

    local transferCount = 0
    if Config.UseTransferCount then
        local result = MySQL.Sync.fetchAll('SELECT transfer_count FROM owned_vehicles WHERE plate = @plate', {
            ['@plate'] = plate
        })
        if result[1] and result[1].transfer_count then
            transferCount = result[1].transfer_count
        end

        if transferCount <= 0 then
            TriggerClientEvent('esx:showNotification', sellerId, _L('no_transfer_left'))
            return
        end
    end

    TriggerClientEvent('contract:receiveOffer', buyerId, {
        model = model,
        plate = plate,
        price = price,
        sellerId = sellerId,
        sellerName = xPlayer.getName(),
        buyerId = buyerId,
        transferCount = transferCount
    })
end)

RegisterNetEvent('contract:acceptOffer')
AddEventHandler('contract:acceptOffer', function(data)
    local sellerId = data.sellerId
    local buyerId = data.buyerId
    local price = tonumber(data.price)
    local plate = data.plate

    local xPlayer = ESX.GetPlayerFromId(sellerId)
    local tPlayer = ESX.GetPlayerFromId(buyerId)

    if not xPlayer or not tPlayer then
        if xPlayer then TriggerClientEvent('esx:showNotification', sellerId, _L('playeroffline')) end
        if tPlayer then TriggerClientEvent('esx:showNotification', buyerId, _L('playeroffline')) end
        return
    end

    if tPlayer.getMoney() < price then
        TriggerClientEvent('esx:showNotification', buyerId, _L('notenoughmoney'))
        TriggerClientEvent('esx:showNotification', sellerId, _L('buyer_notenoughmoney'))
        return
    end

    TriggerEvent('contract:sellVehicle', sellerId, buyerId, plate, price)
end)

ESX.RegisterServerCallback('contract:getTransferCount', function(source, cb, plate)
    local result = MySQL.Sync.fetchAll('SELECT transfer_count FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    })
    if result[1] and result[1].transfer_count then
        cb(result[1].transfer_count)
    else
        cb(0)
    end
end)

RegisterCommand('addtransfer', function(source, args, raw)
    local xPlayer = ESX.GetPlayerFromId(source)
    if source ~= 0 and (not xPlayer or xPlayer.getGroup() ~= "admin") then
        if source ~= 0 then
            TriggerClientEvent('esx:showNotification', source, _L('no_permission'))
        end
        return
    end

    local plate = args[1]
    local addCount = tonumber(args[2])
    if not plate or not addCount then
        if source ~= 0 then
            TriggerClientEvent('esx:showNotification', source, _L('addtransfer_usage'))
        end
        return
    end

    local result = MySQL.Sync.fetchAll('SELECT transfer_count FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    })
    if not result[1] then
        if source ~= 0 then
            TriggerClientEvent('esx:showNotification', source, _L('vehicle_not_found'))
        end
        return
    end

    MySQL.Sync.execute('UPDATE owned_vehicles SET transfer_count = transfer_count + @add WHERE plate = @plate', {
        ['@add'] = addCount,
        ['@plate'] = plate
    })

    if source ~= 0 then
        TriggerClientEvent('esx:showNotification', source, _L('addtransfer_success', addCount, plate))
    end
end, false)