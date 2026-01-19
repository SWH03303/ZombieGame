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

function Explosion.Knockback(self: Explosion, char: Model, power: number, duration: number)
	local hrp = char.HumanoidRootPart
	local hum = char.Humanoid :: Humanoid
	if not (hrp and hum) then
		warn("Explosion Knockback couldnt load some instances")
	end

	local player = players:GetPlayerFromCharacter(char)

	local upVector = hrp.CFrame.UpVector * power
	local vectorVelocity = hrp.CFrame.LookVector * power + upVector
	if player then
		if hum.FloorMaterial == Enum.Material.Air then
			local moveDir = hum.MoveDirection
			local localDir = hrp.CFrame:VectorToObjectSpace(moveDir)

			local x = localDir.X
			local z = localDir.Z
			if (x == 0 and z == 0) or (z < -0.8) then
				vectorVelocity = hrp.CFrame.LookVector * power + upVector
			elseif z > 0.8 then
				vectorVelocity = -hrp.CFrame.LookVector * power + upVector
			elseif x > 0.8 then
				vectorVelocity = hrp.CFrame.RightVector * power + upVector
			elseif x < -0.8 then
				vectorVelocity = -hrp.CFrame.RightVector * power + upVector
			end
		else
			vectorVelocity = -hrp.CFrame.RightVector * power
		end
	else
		print("fling npc")
		--uhh
	end
	applyKnockback(hrp.RootAttachment, vectorVelocity, Vector3.new(40000, 40000, 40000), duration)
end

return Explosion
