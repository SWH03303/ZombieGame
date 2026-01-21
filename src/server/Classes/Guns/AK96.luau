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

local Explosion = require(attacks.Explosion)

packets.useAbility.OnServerEvent:Connect(function(player: Player, info: abilityInfo)
	local char = player.Character
	local hrp = char.HumanoidRootPart :: Part

	if caster == nil then
		local function onHit(bullet)
			for _, p in pairs(pCache.InUse) do
				if p == bullet then
					local explosion = Explosion.new(Vector3.new(20, 20, 20), CFrame.new(bullet.Position), true, 0.5)

					explosion.hitbox.OnHit:Once(function(hitCharacters)
						for _, hitChar in ipairs(hitCharacters) do
							local hitPlayer = players:GetPlayerFromCharacter(hitChar)
							local humanoid = hitChar:FindFirstChildOfClass("Humanoid")
							humanoid:TakeDamage(10)
							Explosion.Knockback(explosion, hitChar, 100, 0.25)
							if hitPlayer then
								Explosion.AddSpeed(hitPlayer, 100, 0, true)
							end
						end
					end)

					pCache:ReturnPart(bullet)
					return
				end
			end
			return
		end
		caster = projectile.NewSimpleCaster(onHit, pCache, 100, Vector3.new(0, -50, 0), workspace.Projectiles, { char })
	end

	projectile.Fire(caster, info.position, info.direction, info.power)
end)

function AK96:Destroy()
	print("ak destroyed")
end

return AK96
