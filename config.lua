Config = {}

Config.Locale = 'en' -- only applies to notifications, you need to translate the UI yourself in the html

Config.Contract = {
    UseAnim = false, -- requires ox_lib or you can edit the animation in the client/main.lua
}

Config.UseTransferCount = true -- set to true if you want to limit the number of transfers for each vehicle
Config.DefaultTransferCount = 3 -- default transfer count for each vehicle

Config.PriceMin = 1
Config.PriceMax = 9999999

Config.DiscordLog = {
    Enable = true, -- enable or disable Discord logging
    Webhook = "https://discord.com/api/webhooks/xxxxxxxxxxxx/xxxxxxxxx" -- your Discord webhook URL
}

Config.Locales = {
    ['en'] = {
        ['soldvehicle'] = 'You sold the vehicle with plate ~y~%s~s~ and received ~g~$%s~s~ from the buyer.',
        ['boughtvehicle'] = 'You bought the vehicle with plate ~y~%s~s~ for ~g~$%s~s~.',
        ['playeroffline'] = 'The player is not online!',
        ['notyourcar'] = 'You do not own this vehicle!',
        ['notenoughmoney'] = 'You do not have enough money to buy this vehicle!',
        ['buyer_notenoughmoney'] = 'The buyer does not have enough money!',
        ['novehicle'] = 'No vehicle nearby!',
        ['no_transfer_left'] = 'This vehicle has no transfer left!',
        ['no_permission'] = 'You do not have permission to use this command!',
        ['addtransfer_usage'] = 'Usage: /addtransfer [plate] [count]',
        ['vehicle_not_found'] = 'Vehicle not found!',
        ['addtransfer_success'] = 'Added %s transfer(s) to plate %s.',
    },
        ['vi'] = {
        ['soldvehicle'] = 'Bạn đã bán xe có biển số ~y~%s~s~ và nhận được ~g~$%s~s~ từ người mua.',
        ['boughtvehicle'] = 'Bạn đã mua xe có biển số ~y~%s~s~ với giá ~g~$%s~s~.',
        ['playeroffline'] = 'Người chơi không trực tuyến!',
        ['notyourcar'] = 'Bạn không sở hữu chiếc xe này!',
        ['notenoughmoney'] = 'Bạn không đủ tiền để mua xe này!',
        ['buyer_notenoughmoney'] = 'Người mua không có đủ tiền!',
        ['novehicle'] = 'Không có xe nào gần bạn!',
        ['no_transfer_left'] = 'Xe này đã hết lượt chuyển nhượng!',
        ['no_permission'] = 'Bạn không có quyền sử dụng lệnh này!',
        ['addtransfer_usage'] = 'Cú pháp: /addtransfer [biển số] [số lượt]',
        ['vehicle_not_found'] = 'Không tìm thấy xe!',
        ['addtransfer_success'] = 'Đã thêm %s lượt chuyển cho xe biển số %s.',
    }
}