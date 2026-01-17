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

local function onCharacterAdded(char: Model)
	if char == nil then
		return
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
