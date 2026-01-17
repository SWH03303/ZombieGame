local movementService = {}

local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local keybindModule = modules:WaitForChild("Game"):WaitForChild("Keybind")
local runService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

player.CharacterAdded:Connect(function(char)
	local hrp = char:WaitForChild("HumanoidRootPart")
	local vectorForce = Instance.new("VectorForce", hrp)
	vectorForce.Attachment0 = hrp.RootAttachment
end)

return movementService
