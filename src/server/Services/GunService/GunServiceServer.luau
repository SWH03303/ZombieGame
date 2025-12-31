--!strict
local LogReporterService = game:GetService("LogReporterService")
local rs = game:GetService("ReplicatedStorage")
local shared = rs.Shared
local modules = shared.Modules
local packet = require(modules.Core.Packets)

local Shared = {}

packet.shoot.OnServerInvoke = function(player, shooter, enemy, hitPart)
	print(`{player.Name} shot {enemy.Name} in the {hitPart} dealing 67 HP (SERVER)`)
	return 67
end

return Shared
