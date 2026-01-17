--!strict
local Shared = {
	CoolDown = 0.5,
}

print("innit dash")

local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local assets = rs:WaitForChild("Assets")
local services = shared:WaitForChild("Services")
local modules = shared:WaitForChild("Modules")
local keybindModule = require(modules:WaitForChild("Game"):WaitForChild("Keybind"))
local runService = game:GetService("RunService")
local debris = game:GetService("Debris")
local vfxService = require(services:WaitForChild("VfxService"):WaitForChild("VfxServiceClient"))
local Janitor = require(rs:WaitForChild("Packages"):WaitForChild("Janitor"))
local janitor = Janitor.new()

local player = game:GetService("Players").LocalPlayer
local char = player.Character
local hrp = char.HumanoidRootPart

local canDash = true
local dashSound = require(modules.Platform.CloneSound)(
	assets:WaitForChild("Sounds"):WaitForChild("Movement"):WaitForChild("Dash"),
	hrp
)
local dashAction = keybindModule.GetAction("InGame", "Dash")
dashAction.KeyboardBinding.KeyCode = Enum.KeyCode.LeftShift
janitor:Add(
	dashAction.Pressed:Connect(function()
		if not canDash then
			return
		end
		canDash = false
		task.delay(Shared.CoolDown, function()
			canDash = true
		end)

		dashSound:Play()
		local slide = Instance.new("LinearVelocity")
		slide.MaxAxesForce = Vector3.new(40000, 0, 40000)
		slide.ForceLimitMode = Enum.ForceLimitMode.PerAxis

		local GetMoveVector =
			require(player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule")):GetMoveVector()
		local x = GetMoveVector.X
		local z = GetMoveVector.Z

		if (x == 0 and z == 0) or (z < -0.8) then
			slide.VectorVelocity = char.HumanoidRootPart.CFrame.LookVector * 65
		elseif z > 0.8 then
			slide.VectorVelocity = -char.HumanoidRootPart.CFrame.LookVector * 65
		elseif x > 0.8 then
			slide.VectorVelocity = char.HumanoidRootPart.CFrame.RightVector * 65
		elseif x < -0.8 then
			slide.VectorVelocity = -char.HumanoidRootPart.CFrame.RightVector * 65
		end

		slide.Parent = char.HumanoidRootPart.RootAttachment
		slide.Attachment0 = char.HumanoidRootPart.RootAttachment

		vfxService.EnableSpeedlines(char, 1500)

		task.delay(0.5, function()
			vfxService.DisableSpeedlines()
		end)
		debris:AddItem(slide, 0.25)
	end),
	"Disconnect"
)

return Shared
