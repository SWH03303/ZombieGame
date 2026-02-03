local ReplicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char: Model)
		char.Parent = workspace.Ingame
	end)
end)

local Hitbox = require(ReplicatedStorage.Packages.Hitbox)
local playerDataService = require(script.Services.PlayerDataService.PlayerDataServiceServer)
local gunService = require(script.Services.GunService.GunServiceServer)
local enemyService = require(script.Services.EnemyService.EnemyServiceServer)
