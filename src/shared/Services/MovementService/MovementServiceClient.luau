--!strict
local movementService = {}

local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local movementClass = shared:WaitForChild("Classes"):WaitForChild("Movement")
local modules = shared:WaitForChild("Modules")
local keybindModule = require(modules:WaitForChild("Game"):WaitForChild("Keybind"))
local runService = game:GetService("RunService")
local Janitor = require(rs:WaitForChild("Packages"):WaitForChild("Janitor"))
local janitor = Janitor.new()
local player = game:GetService("Players").LocalPlayer
local gravityVector = game.Workspace.Gravity

local playerStats = {
	Health = 100,
	MaxHealth = 100,
	WalkSpeed = 20,
	JumpHeight = 3.6,
}
local HiddenStats = {
	MaxSpeed = 50,
}

local function onCharacterAdded(char: Model)
	if char == nil then
		return
	end
	local hum = char.Humanoid
	for stat, val in playerStats do
		hum[stat] = val
	end
	local hrp = char:WaitForChild("HumanoidRootPart") :: Part
	local vectorForce = Instance.new("VectorForce", hrp)
	vectorForce.Attachment0 = hrp.RootAttachment
	vectorForce.Enabled = true
	vectorForce.Force = Vector3.new(0, gravityVector * hrp.AssemblyMass * 0.5, 0)

	local dash = require(movementClass:WaitForChild("Dash"))
	dash.CoolDown = 1
end
onCharacterAdded(player.Character)
player.CharacterAdded:Connect(onCharacterAdded)

return movementService
