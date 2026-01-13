local LogReporterService = game:GetService("LogReporterService")
local rs = game:GetService("ReplicatedStorage")
local shared = rs.Shared
local modules = shared.Modules
local class = shared.Classes
local guns = class.Guns
local packet = require(modules.Core.Packets)

local Shared = {}

local gunStats = require(guns.GunStats)
print(gunStats)

packet.shoot.OnServerInvoke = function(player, shooter, enemy, hitPart, gunName)
	--print(gunStats)
	local damage = print(
		`{player.Name} shot {enemy.Name} in the {hitPart} dealing {gunStats[gunName].Damage} HP using {gunName} (SERVER)`
	)
	return 67
end

return Shared
