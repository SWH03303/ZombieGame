local testDummy = {}
testDummy.__index = testDummy

local ss = game:GetService("ServerScriptService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local classes = shared:WaitForChild("Classes")
local packages = rs:WaitForChild("Packages")
local assets = rs:WaitForChild("Assets")
local enemyClass = ss.Server.Classes.Enemies
local followBehavior = require(enemyClass.Behavior.Follow)
local packets = require(modules:WaitForChild("Core"):WaitForChild("Packets"))
local Hitbox = require(packages:WaitForChild("Hitbox"))
local Janitor = require(packages.Janitor)

export type testDummy = {}

function testDummy.new(position: Vector3): testDummy
	local self = setmetatable({}, testDummy)
	local janitor = Janitor.new()

	local clone = assets.Models.Enemies.TestDummy:Clone() :: Model
	clone:PivotTo(CFrame.new(position))
	clone.Parent = workspace.Camera.ServerIngame

	self.Model = clone
	local newFollow = followBehavior.new(clone)
	local hum = clone.Humanoid :: Humanoid
	local hrp = clone.HumanoidRootPart :: Part

	janitor:Add(
		runService.Heartbeat:Connect(function(dt: number)
			newFollow:Follow(dt)
		end),
		"Disconnect"
	)

	janitor:Add(
		hrp:GetPropertyChangedSignal("Parent"):Connect(function()
			if not hrp.Parent then
				janitor:Cleanup()
				janitor:Destroy()
				print("destroyed")
			end
		end),
		"Disconnect"
	)

	janitor:Add(
		hum.Died:Once(function()
			janitor:Cleanup()
			janitor:Destroy()
		end),
		"Disconnect"
	)

	return self
end

return testDummy
