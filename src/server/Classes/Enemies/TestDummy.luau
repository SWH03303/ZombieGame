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

function testDummy.new(position: Vector3, janitor: typeof(Janitor.new())): testDummy
	local self = setmetatable({}, testDummy)

	local clone = assets.Models.Enemies.TestDummy:Clone() :: Model
	clone:PivotTo(CFrame.new(position))
	clone.Parent = workspace.Ingame

	self.Model = clone
	local newFollow = followBehavior.new(clone)

	janitor:Add(
		runService.Heartbeat:Connect(function(dt: number)
			newFollow:Follow(dt)
		end),
		"Disconnect"
	)

	return self
end

return testDummy
