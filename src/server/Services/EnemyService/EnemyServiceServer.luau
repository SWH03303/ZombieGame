local enemyService = {}

local rs = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerScriptService")
local shared = rs.Shared
local modules = shared.Modules
local serverClass = ss.Server.Classes
local enemyClass = serverClass.Enemies
local assets = rs.Assets
local Janitor = require(rs.Packages.Janitor)
local janitor = Janitor.new()

local packets = require(modules.Core.Packets)

packets.spawnRequest.OnServerEvent:Connect(function(player: Player, name: string, position: Vector3)
	if player.Name ~= "Hembegur" then
		return
	end
	require(enemyClass[name]).new(position)
end)

return enemyService
