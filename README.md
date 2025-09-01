<p align="center">
    <img width="140" src="https://icons.iconarchive.com/icons/iconarchive/red-orb-alphabet/128/Letter-M-icon.png" />  
    <h1 align="center">Hi 👋, I'm MaDHouSe</h1>
    <h3 align="center">A passionate allround developer </h3>    
</p>

<p align="center">
    <a href="https://github.com/MaDHouSe79/mh-lobbies/issues">
        <img src="https://img.shields.io/github/issues/MaDHouSe79/mh-lobbies"/>
    </a>
    <a href="https://github.com/MaDHouSe79/mh-lobbies/watchers">
        <img src="https://img.shields.io/github/watchers/MaDHouSe79/mh-lobbies"/> 
    </a> 
    <a href="https://github.com/MaDHouSe79/mh-lobbies/network/members">
        <img src="https://img.shields.io/github/forks/MaDHouSe79/mh-lobbies"/> 
    </a>  
    <a href="https://github.com/MaDHouSe79/mh-lobbies/stargazers">
        <img src="https://img.shields.io/github/stars/MaDHouSe79/mh-lobbies?color=white"/> 
    </a>
    <a href="https://github.com/MaDHouSe79/mh-lobbies/blob/main/LICENSE">
        <img src="https://img.shields.io/github/license/MaDHouSe79/mh-lobbies?color=black"/> 
    </a>      
</p>

<p align="center">
    <img src="https://komarev.com/ghpvc/?username=MaDHouSe79&label=Profile%20views&color=3464eb&style=for-the-badge&logo=star&abbreviated=true" alt="MaDHouSe79" style="padding-right:20px;" />
</p>

# MH Lobbies (QB/ESX)
- Have multiple lobbies(dimensions) in your single rp server, you can `add/delete` more lobbies very easy.
- There is a `cheat` lobbie build in, this will send the cheater to a cheater lobbie with `cheat mode` enabled,
- all other players can also join this lobbie when they use the `ticket machine` 
- and the `cheat mode` is disabled so you can `hit or shot` the cheaters, 
- and the cheater can't do anything about it, so have for with that.
-
- A cheater can't: `Shoot` `Kill` or `Run` and is unable to use `taget` and `menu`.
- All other players are able to `Shoot` `Kill` `Walk` `Run` and are able to `use` `target` or `E` for the `ticket system` to go to another lobbie.
- Also you are not able to see other players in other lobbies(dimensions).

# Multiple default lobbies build in
- `Admin Lobbie`
- - for admins only
- `Main Lobbie` 
- - when you fist join the server this is the main lobbie
- `Gang Lobbie` 
- - you can shot gang peds en shot everting you see. (most peds here are aggressive)
- `Zombie Lobbie`
- - you can kill all the zombies or die. (zombies are aggressive)
- `Cheater Lobbie`
- - when you add a cheater this is the only lobbie he can join
- - other players can join as well en kill the cheater and go back to the main lobbie

# Commands (Admins Only)
- `newlobbie` (create e new lobbie)
- `changelobbie [player ID] [lobbie ID]` (change lobbies)
- `setcheater [player ID]` (set a player as cheater)
- `removecheater [player ID]` (remove a player as cheater)

# Config Files
- Main file `mh-lobbies/core/sv_config.lua` (main core config file)
- Main Lobbie file `mh-lobbies/server/configs/main.lua` (don't remove, this are default lobbies)
- Optional Lobbie files `mh-lobbies/server/configs/*.lua` (every file except the `main.lua`)

# Mark a player as cheater
- use this server side, this will be saved in the database, and when this player joins the server the next time, it will automaticly go to the cheat lobbie.
- You can only see a cheater when you are in the cheat lobby.
```lua
local player_server_id = source
-- Add a Cheater
exports['mh-lobbies']:ToggleCheater({id = player_server_id, isCheater = true})
-- Remove a Cheater
exports['mh-lobbies']:ToggleCheater({id = player_server_id, isCheater = false})
```

# Load Script
- Load this script after the [qb or esx] framework.
```conf
# For QB
ensure [qb]
ensure mh-lobbies

# For ESX 
ensure [esx_addons]
ensure mh-lobbies
```

# LICENSE
[GPL LICENSE](./LICENSE)<br />
&copy; [MaDHouSe79](https://www.youtube.com/@MaDHouSe79)