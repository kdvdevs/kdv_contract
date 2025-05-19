# kdv_contract
A modern, safe, and customizable vehicle contract system for ESX-based FiveM servers.
Features
Player-to-player vehicle contracts:
Players can sell vehicles to each other via an in-game contract UI.

Transfer count limit:
Optionally limit the number of times a vehicle can be transferred (configurable).

Configurable price range:
Set minimum and maximum allowed sale prices in config.lua.

Multilingual notifications:
Supports English and Vietnamese (easily extendable).

Safe transactions:
Checks vehicle ownership, buyer’s money, and online status. Fully automated and secure.

Discord logging:
Sends detailed transaction logs (seller, buyer, vehicle, price, transfer count) to a Discord webhook. Toggleable in config.

Admin transfer count command:
Admins can use /addtransfer [plate] [count] to add transfer counts to any vehicle.

ESX integration:
Uses ESX for player, money, and inventory management.

Modern, customizable UI:
Responsive HTML/CSS UI, easy to restyle.

Dependencies
ESX Legacy
mysql-async or oxmysql (edit server_scripts if using oxmysql)
ox_lib (for some optional features)
FontAwesome CDN (for UI icons)
Installation
Clone or download this repository to your resources folder.

Configure your dependencies in fxmanifest.lua as needed:

Default is mysql-async.
If you use oxmysql, replace the server_scripts line:
Edit config.lua to your preferences:

Set price limits, transfer count, Discord webhook, language, etc.
Add the item contract to your ESX items database (if not already present).

Add the resource to your server.cfg:

Restart your server.

Usage
Players use the contract item near their vehicle to initiate a sale.
Admins can add transfer counts with /addtransfer [plate] [count].
All transactions are logged to Discord if enabled.
License
MIT

Ready for GitHub!
You can copy, adjust, and use this as your README.md.6. Restart your server.

Usage
Players use the contract item near their vehicle to initiate a sale.
Admins can add transfer counts with /addtransfer [plate] [count].
All transactions are logged to Discord if enabled.
License
MIT

