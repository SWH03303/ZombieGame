local players = game:GetService("Players")

local playerDataService = require(script.Services.PlayerDataService.PlayerDataServiceServer)
local gunService = require(script.Services.GunService.GunServiceServer)

require(game.ReplicatedStorage.Shared.Classes.Attacks.Explosion)()
