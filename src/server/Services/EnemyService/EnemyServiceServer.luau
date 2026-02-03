local enemyService = {}

local Workspace = game:GetService("Workspace")
local rs = game:GetService("ReplicatedStorage")
local shared = rs.Shared
local modules = shared.Modules
local assets = rs.Assets

local packets = require(modules.Core.Packets)

packets.spawnRequest.OnServerEvent:Connect(function(player: Player, name: string, position: Vector3)
	if player.Name ~= "Hembegur" then
		return
	end

	local clone = assets.Models.Enemies[name]:Clone() :: Model
	clone:PivotTo(CFrame.new(position))
	clone.Parent = workspace
end)

return enemyService
