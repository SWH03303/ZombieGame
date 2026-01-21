local Projectile = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local packages = rs:WaitForChild("Packages")
local packets = require(modules:WaitForChild("Core"):WaitForChild("Packets"))
local fastcast = require(packages:WaitForChild("Fastcastredux"))

function Projectile.NewCaster() --TRY to make the module handle all the fastcast work!
	local caster = fastcast.new()
	local behavior = fastcast.newBehavior()

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = { workspace:WaitForChild("ProjectileTest") }
	behavior.RaycastParams = params
	behavior.Acceleration = Vector3.new(0, -50, 0)
	behavior.MaxDistance = 699
	behavior.AutoIgnoreContainer = true
	behavior.CosmeticBulletTemplate = workspace.Ball
	behavior.CosmeticBulletContainer = workspace

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
			cosmeticBulletObject:Destroy()
		end
	)

	task.spawn(function()
		task.wait(1)
		while true do
			task.wait(0.2)
			local goalpos = workspace.ProjectileTest.CFrame * CFrame.new(0, 0, -20)
			local dir = (goalpos.Position - workspace.ProjectileTest.Position).Unit
			caster:Fire(workspace.ProjectileTest.Attachment.WorldPosition, dir, 50, behavior)
		end
	end)
end

return Projectile
