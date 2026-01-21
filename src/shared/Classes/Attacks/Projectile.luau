local Projectile = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local packages = rs:WaitForChild("Packages")
local packets = require(modules:WaitForChild("Core"):WaitForChild("Packets"))
local fastcast = require(packages:WaitForChild("Fastcastredux"))

export type fastcastType = typeof(fastcast.new())

export type SimpleCaster = {
	caster: typeof(fastcast.new()),
	behavior: typeof(fastcast.newBehavior()),
}
function Projectile.NewSimpleCaster(
	onHit,
	BulletProvider,
	MaxDistance: number,
	Acceleration: Vector3,
	BulletContainer,
	Filter
): SimpleCaster --TRY to make the module handle all the fastcast work!
	local self = setmetatable({}, Projectile)

	local caster = fastcast.new()
	local behavior = fastcast.newBehavior()

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = Filter
	behavior.RaycastParams = params
	behavior.Acceleration = Acceleration or Vector3.new(0, -50, 0)
	behavior.MaxDistance = MaxDistance or 200
	behavior.AutoIgnoreContainer = true
	behavior.CosmeticBulletProvider = BulletProvider
	behavior.CosmeticBulletContainer = BulletContainer or workspace.Projectiles

	caster.LengthChanged:Connect(
		function(
			casterThatFired,
			lastPoint: Vector3,
			rayDir: Vector3,
			displacement: number,
			segmentVelocity: Vector3,
			cosmeticBulletObject: Instance
		)
			local newPos = lastPoint + (rayDir * displacement)
			cosmeticBulletObject.Position = newPos
		end
	)

	caster.RayHit:Connect(
		function(casterThatFired, RaycastResult, segmentVelocity: Vector3, cosmeticBulletObject: Instance)
			onHit(cosmeticBulletObject)
		end
	)

	caster.CastTerminating:Connect(function(activeCast)
		onHit(activeCast.RayInfo.CosmeticBulletObject)
	end)

	self.caster = caster
	self.behavior = behavior
	return self
end

function Projectile.Fire(self: SimpleCaster, originalPos: Vector3, direction: Vector3, power: number)
	--[[
	local goalpos = workspace.ProjectileTest.CFrame * CFrame.new(0, 0, -20)
	local dir = (goalpos.Position - workspace.ProjectileTest.Position).Unit]]
	self.caster:Fire(originalPos, direction, power, self.behavior)
end

--[[
task.spawn(function()
		task.wait(1)
		while true do
			task.wait(0.2)
			
		end
	end)
]]

return Projectile
