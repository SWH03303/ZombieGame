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

while true do
	local explosion = require(game.ReplicatedStorage.Shared.Classes.Attacks.Explosion).new(
		Vector3.new(10, 10, 10),
		workspace.HitboxTest.CFrame,
		true,
		0.5
	)

	explosion.hitbox.OnHit:Connect(function(hitCharacters)
		for _, character in ipairs(hitCharacters) do
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			humanoid:TakeDamage(10)
		end
	end)
	task.wait(1)
end
