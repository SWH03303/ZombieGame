local testDummy = {}
testDummy.__index = testDummy

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local packages = rs:WaitForChild("Packages")
local assets = rs:WaitForChild("Assets")
local packets = require(modules:WaitForChild("Core"):WaitForChild("Packets"))
local Hitbox = require(packages:WaitForChild("Hitbox"))
local Janitor = require(packages.Janitor)

export type testDummy = {}

function testDummy.new(position: Vector3, janitor: typeof(Janitor.new())): testDummy
	local self = setmetatable({}, testDummy)

	local clone = assets.Models.Enemies.TestDummy:Clone() :: Model
	clone:PivotTo(CFrame.new(position))
	clone.Parent = workspace

	self.Model = clone
	local hrp = self.Model.HumanoidRootPart :: Part
	local hum = self.Model.Humanoid :: Humanoid

	local elapsed = 0
	local moveElapsed = 0
	local currentTarget
	janitor:Add(
		runService.Heartbeat:Connect(function(dt: number)
			elapsed += dt
			if elapsed > 1 then
				local closet = 9999999
				for _, player in pairs(players:GetPlayers()) do
					local playerChar = player.Character
					if playerChar then
						local dis = (hrp.Position - playerChar.HumanoidRootPart.Position).Magnitude
						if dis < closet then
							closet = dis
							currentTarget = playerChar
						end
					end
				end
				elapsed = 0
			end

			moveElapsed += dt
			if currentTarget and moveElapsed > 0.3 then
				hum:MoveTo(currentTarget.HumanoidRootPart.Position)
				moveElapsed = 0
			end
		end),
		"Disconnect"
	)

	return self
end

return testDummy
