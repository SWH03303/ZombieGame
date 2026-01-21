local AK96 = {}

local sss = game:GetService("ServerScriptService")
local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local shared = rs.Shared
local modules = shared.Modules
local assets = rs.Assets
local packets = require(modules.Core.Packets)
local sharedClasses = shared.Classes
local attacks = sharedClasses.Attacks
local projectile = require(attacks.Projectile)
local partCacheModule = require(rs:WaitForChild("Packages"):WaitForChild("PartCache"))
local pCache = partCacheModule.new(assets.Vfx.Ball, 3)

export type abilityInfo = {
	cframe: CFrame,
	position: Vector3,
	direction: Vector3,
	power: number,
}

local caster = nil

packets.useAbility.OnServerEvent:Connect(function(player: Player, info: abilityInfo)
	local char = player.Character
	local hrp = char.HumanoidRootPart :: Part

	if caster == nil then
		function onHit(bullet)
			pCache:ReturnPart(bullet)
		end
		caster = projectile.NewSimpleCaster(onHit, pCache, 100, Vector3.new(0, -50, 0), workspace.Projectiles, { char })
	end

	projectile.Fire(caster, info.position, info.direction, info.power)
end)

return AK96
