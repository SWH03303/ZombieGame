local Explosion = {}
Explosion.__index = Explosion

local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local packages = rs:WaitForChild("Packages")
local Hitbox = require(packages:WaitForChild("Hitbox"))
local applyKnockback = require(modules:WaitForChild("Game"):WaitForChild("Applyknockback"))

export type Explosion = {
	hitbox: typeof(Hitbox.new()),
}

function Explosion.new(size: Vector3, cframe: CFrame, debug: boolean, lifeTime: number): Explosion
	local self = setmetatable({}, Explosion)

	local hitbox = Hitbox.new({
		InitialCframe = cframe,
		SizeOrPart = size,
		Debug = debug,
		LifeTime = lifeTime,
	})
	hitbox:Start()

	self.hitbox = hitbox

	return self
end

function Explosion.Knockback(self: Explosion, char: Model)
	local hrp = char.HumanoidRootPart
	local player = players.GetPlayerFromCharacter(char)
	local vectorVelocity

	if player then
		local GetMoveVector =
			require(player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule")):GetMoveVector()
		local x = GetMoveVector.X
		local z = GetMoveVector.Z

		if (x == 0 and z == 0) or (z < -0.8) then
			vectorVelocity = hrp.CFrame.LookVector * 65
		elseif z > 0.8 then
			vectorVelocity = -hrp.CFrame.LookVector * 65
		elseif x > 0.8 then
			vectorVelocity = hrp.CFrame.RightVector * 65
		elseif x < -0.8 then
			vectorVelocity = -hrp.CFrame.RightVector * 65
		end
	else
		local velocity = hrp.AssemblyLinearVelocity
		print(velocity.Magnitude > 0 and velocity.Unit or Vector3.zero, char.HumanoidRootPart.CFrame.LookVector)
	end
	applyKnockback(att, velocity, maxAxesForce, duration)
end

return Explosion
