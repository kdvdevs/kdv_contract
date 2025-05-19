ESX = exports['es_extended']:getSharedObject()

local function _L(key, ...)
    local locale = Config.Locale or 'en'
    local str = Config.Locales[locale][key] or key
    return string.format(str, ...)
end

RegisterNetEvent('contract:getVehicle')
AddEventHandler('contract:getVehicle', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = ESX.Game.GetClosestVehicle(coords)
    local vehiclecoords = GetEntityCoords(vehicle)
    local vehDistance = GetDistanceBetweenCoords(coords, vehiclecoords, true)

    if DoesEntityExist(vehicle) and (vehDistance <= 3) then
        local vehProps = ESX.Game.GetVehicleProperties(vehicle)
        local model = GetDisplayNameFromVehicleModel(vehProps.model)
        local plate = vehProps.plate

        ESX.TriggerServerCallback('contract:getTransferCount', function(transferCount)
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "openContract",
                data = {
                    model = model,
                    plate = plate,
                    transferCount = transferCount,
                    useTransferCount = Config.UseTransferCount,
                    priceMin = Config.PriceMin,
                    priceMax = Config.PriceMax
                }
            })
        end, plate)
    else
        ESX.ShowNotification(_L('novehicle'))
    end
end)

RegisterNUICallback('submitContract', function(data, cb)
    local price = tonumber(data.price)
    local buyerId = tonumber(data.buyerId)
    local plate = data.plate
    local model = data.model
    TriggerServerEvent('contract:sendOffer', buyerId, price, plate, model)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('closeContract', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNetEvent('contract:receiveOffer')
AddEventHandler('contract:receiveOffer', function(data)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openBuyContract",
        data = {
            model = data.model,
            plate = data.plate,
            price = data.price,
            sellerId = data.sellerId,
            sellerName = data.sellerName,
            buyerId = data.buyerId,
            transferCount = data.transferCount
        }
    })
end)

RegisterNUICallback('acceptBuyContract', function(data, cb)
    TriggerServerEvent('contract:acceptOffer', data)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('declineBuyContract', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNetEvent('contract:showAnim')
AddEventHandler('contract:showAnim', function(player)
    local ped = PlayerPedId()

    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, false)

    lib.progressBar({
        duration = 20000, 
        label = 'Đang ký hợp đồng...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
    })

    ClearPedTasks(ped)
end)