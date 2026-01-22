--!strict
local Shared = {
	CoolDown = 0.5,
}

local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local assets = rs:WaitForChild("Assets")
local services = shared:WaitForChild("Services")
local modules = shared:WaitForChild("Modules")
local keybindModule = require(modules:WaitForChild("Game"):WaitForChild("Keybind"))
local applyKnockback = require(modules:WaitForChild("Game"):WaitForChild("Applyknockback"))
local runService = game:GetService("RunService")
local debris = game:GetService("Debris")
local vfxService = require(services:WaitForChild("VfxService"):WaitForChild("VfxServiceClient"))
local Janitor = require(rs:WaitForChild("Packages"):WaitForChild("Janitor"))
local janitor = Janitor.new()

local player = game:GetService("Players").LocalPlayer

local canDash = true

local dashAction = keybindModule.GetAction("InGame", "Dash")
dashAction.KeyboardBinding.KeyCode = Enum.KeyCode.LeftShift
dashAction.Pressed:Connect(function()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:FindFirstChild("HumanoidRootPart") :: Part

	if not hrp then
		return
	end

	local dashSound = require(modules.Platform.CloneSound)(
		assets:WaitForChild("Sounds"):WaitForChild("Movement"):WaitForChild("Dash"),
		hrp
	)
	if not canDash then
		return
	end
	canDash = false
	task.delay(Shared.CoolDown, function()
		canDash = true
	end)

	dashSound:Play()

	local GetMoveVector =
		require(player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule")):GetMoveVector()
	local x = GetMoveVector.X
	local z = GetMoveVector.Z

	local vectorVelocity

	if (x == 0 and z == 0) or (z < -0.8) then
		vectorVelocity = hrp.CFrame.LookVector * 65
	elseif z > 0.8 then
		vectorVelocity = -hrp.CFrame.LookVector * 65
	elseif x > 0.8 then
		vectorVelocity = hrp.CFrame.RightVector * 65
	elseif x < -0.8 then
		vectorVelocity = -hrp.CFrame.RightVector * 65
	end

	applyKnockback(hrp.RootAttachment, vectorVelocity, Vector3.new(40000, 0, 40000), 0.25)
	vfxService.EnableSpeedlines(char, 800, game.Workspace.CurrentCamera.FieldOfView)

	task.delay(0.5, function()
		vfxService.DisableSpeedlines()
	end)
end)

return Shared
