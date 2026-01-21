local AK96 = {}

local sss = game:GetService("ServerScriptService")
local rs = game:GetService("ReplicatedStorage")
local shared = rs.Shared
local modules = shared.Modules
local packets = require(modules.Core.Packets)
local sharedClasses = shared.Classes
local attacks = sharedClasses.Attacks
local projectile = require(attacks.Projectile)

export type abilityInfo = {
	cframe: CFrame,
}

packets.useAbility.OnServerEvent:Connect(function(player: Player, info: abilityInfo)
	projectile.NewCaster()
	print(info)
end)

return AK96
