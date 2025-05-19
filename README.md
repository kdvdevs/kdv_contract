# kdv_contract

A modern, safe, and customizable vehicle contract system for ESX-based FiveM servers.

---
![image](https://github.com/user-attachments/assets/739ce8d2-2a8b-4310-b3d9-25d27a77d938)
![image](https://github.com/user-attachments/assets/342424cc-d03f-4c2e-a0fd-43cfb4966e5f)
![image](https://github.com/user-attachments/assets/6ce436bd-1e19-4498-bfb2-9b2db102ce11)

## Features

- **Player-to-player vehicle contracts:**  
  Players can sell vehicles to each other via an in-game contract UI.

- **Transfer count limit:**  
  Optionally limit the number of times a vehicle can be transferred (configurable).

- **Configurable price range:**  
  Set minimum and maximum allowed sale prices in `config.lua`.

- **Multilingual notifications:**  
  Supports English and Vietnamese (easily extendable).

- **Safe transactions:**  
  Checks vehicle ownership, buyer’s money, and online status. Fully automated and secure.

- **Discord logging:**  
  Sends detailed transaction logs (seller, buyer, vehicle, price, transfer count) to a Discord webhook. Toggleable in config.

- **Admin transfer count command:**  
  Admins can use `/addtransfer [plate] [count]` to add transfer counts to any vehicle.

- **ESX integration:**  
  Uses ESX for player, money, and inventory management.

- **Modern, customizable UI:**  
  Responsive HTML/CSS UI, easy to restyle.

---

## Dependencies

- [ESX Legacy](https://github.com/esx-framework/esx_core)
- [mysql-async](https://github.com/brouznouf/fivem-mysql-async) or [oxmysql](https://github.com/overextended/oxmysql) (edit server_scripts if using oxmysql)
- [ox_lib](https://github.com/overextended/ox_lib) (for some optional features)
- FontAwesome CDN (for UI icons)

---

## Installation

1. **Clone or download this repository** to your `resources` folder.

2. **Configure your dependencies** in `fxmanifest.lua` as needed:
    - Default is `mysql-async`.  
      If you use `oxmysql`, replace the server_scripts line:
      ```lua
      -- '@mysql-async/lib/MySQL.lua',
      '@oxmysql/lib/MySQL.lua',
      ```

3. **Edit `config.lua`** to your preferences:
    - Set price limits, transfer count, Discord webhook, language, etc.

4. **Add the item `contract` to your ESX items database** (if not already present).

5. **Add the resource to your server.cfg:**
    ```
    ensure kdv_contract
    ```

6. **Restart your server.**

---

## Usage

- Players use the contract item near their vehicle to initiate a sale.
- Admins can add transfer counts with `/addtransfer [plate] [count]`.
- All transactions are logged to Discord if enabled.
