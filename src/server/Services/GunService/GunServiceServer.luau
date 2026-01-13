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
	if enemy:GetAttribute("Team") == "Ally" then
		return 67
	end

	local damage
	if hitPart == "Head" then
		damage = gunStats[gunName].CritDamage
		print(`{player.Name} shot {enemy.Name} in the {hitPart} dealing {damage} HP using {gunName} (SERVER)`)
	else
		damage = gunStats[gunName].Damage
		print(`{player.Name} shot {enemy.Name} in the {hitPart} dealing {damage} HP using {gunName} (SERVER)`)
	end
	enemy.Humanoid.Health -= damage
	return 67
end

return Shared
