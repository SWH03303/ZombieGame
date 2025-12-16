--// Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local sounds = rs:WaitForChild("Sounds")

local animations = rs:WaitForChild("Animation")

--// Players Stuff
local player = game:GetService("Players").LocalPlayer
local Char = player.Character or player.CharacterAdded:Wait()
local RootPart = Char:WaitForChild("HumanoidRootPart")
local hum = Char:WaitForChild("Humanoid")
hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

player.CameraMode = 1
local camera = workspace.CurrentCamera

local SlideAnim = hum:WaitForChild("Animator"):LoadAnimation(animations:WaitForChild("Slide_loop"))

--// Varaibles
local isSliding = false
local CanSlide = true
local PosCheck
local CurrentMultiplier = 1
--local BaseSoundVolume = script.Slide_Loop.Volume

--// Objects
local SlideVelocity
local dashDir

local config = Char:WaitForChild("Configuration")

local Settings = {
	WalkSpeed = config.BaseWalkSpeed.Value,
	MaxWalkSpeed = config.MaxWalkSpeed.Value,
	WalkSpeedGain = 10,
	Cooldown = 0.5,
	BaseSpeed = 65,
	HipHeight = {
		Normal = 0,
		Slide = -2,
	},
	MaxMultiplier = 1.5,
	SpeedChangeRate = {
		Forward = 1,
		Upward = 1.5,
		Downward = 1,
	},
	PushOnCancel = true,
	PushVelocity = {
		Forward = 60,
		Up = 40,
	},
	JumpVelocity = {
		Forward = 50,
		Up = 20,
	},
}

local dashSound = sounds:WaitForChild("Movement"):WaitForChild("SlideBegin"):Clone()
dashSound.Parent = Char.Torso
local dashSoundEnd = sounds:WaitForChild("Movement"):WaitForChild("SlideCancel"):Clone()
dashSoundEnd.Parent = Char.Torso
local doubleJumpSound = sounds:WaitForChild("Movement"):WaitForChild("DoubleJump"):Clone()
doubleJumpSound.Parent = Char.Torso

local Params = RaycastParams.new()
Params.FilterDescendantsInstances = { Char }
Params.FilterType = Enum.RaycastFilterType.Exclude

hum.WalkSpeed = Settings.WalkSpeed

local lerpingCou = nil
function lerp(start, goal, t)
	return start + (goal - start) * t
end
function lerpCamera(startPos, goalPos, lerpTime)
	local currTime = 0

	local lerpCou = coroutine.create(function()
		while currTime < lerpTime do
			currTime += RunService.Heartbeat:Wait()
			hum.CameraOffset = lerp(startPos, goalPos, math.min(currTime / lerpTime, 1))
		end
	end)

	coroutine.resume(lerpCou)

	return lerpCou
end

function StopSlide()
	task.spawn(function()
		if lerpingCou ~= nil then
			coroutine.close(lerpingCou)
		end
		lerpingCou = lerpCamera(hum.CameraOffset, Vector3.new(0, 0, 0), 0.2)
	end)

	isSliding = false
	PosCheck:Disconnect()
	SlideVelocity:Destroy()
	--AlignGyro:Destroy()
	SlideAnim:Stop(0.15)
	--script.Slide_Loop:Stop()
	hum.HipHeight = Settings.HipHeight.Normal

	task.delay(Settings.Cooldown, function()
		CanSlide = true
	end)
end

UserInputService.InputBegan:Connect(function(Input, istyping)
	if istyping then
		return
	end
	if Input.KeyCode == Enum.KeyCode.LeftShift then
		--// Cast a ray down to check if player's grounded or no
		local RayDirection = -RootPart.CFrame.UpVector * 5
		local GroundRay = workspace:Raycast(RootPart.Position, RayDirection, Params)

		if isSliding or not CanSlide or not GroundRay then
			return
		end

		isSliding = true
		CanSlide = false
		SlideAnim:Play(0.15)
		dashSound:Play(0)
		hum.HipHeight = Settings.HipHeight.Slide

		local GetMoveVector =
			require(player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule")):GetMoveVector()
		local x = GetMoveVector.X
		local z = GetMoveVector.Z

		SlideVelocity = Instance.new("LinearVelocity")
		SlideVelocity.Parent = RootPart
		SlideVelocity.Attachment0 = RootPart.RootAttachment
		SlideVelocity.MaxAxesForce = Vector3.new(10000, 0, 10000)

		SlideVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis

		if (x == 0 and z == 0) or (z < -0.8) then
			dashDir = "W"
			SlideVelocity.VectorVelocity = RootPart.CFrame.LookVector * Settings.BaseSpeed
			--print("W")
		elseif z > 0.8 then
			dashDir = "S"
			SlideVelocity.VectorVelocity = -RootPart.CFrame.LookVector * Settings.BaseSpeed
			--print("S")
		elseif x > 0.8 then
			dashDir = "D"
			SlideVelocity.VectorVelocity = RootPart.CFrame.RightVector * Settings.BaseSpeed
			--print("D")
		elseif x < -0.8 then
			dashDir = "A"
			SlideVelocity.VectorVelocity = -RootPart.CFrame.RightVector * Settings.BaseSpeed
			--print("A")
		end

		--[[
		AlignGyro = Instance.new("BodyGyro",RootPart)
		AlignGyro.MaxTorque = Vector3.new(3e5,3e5,3e5)
		AlignGyro.P = 10000
		]]
		local PreviousY = 0
		CurrentMultiplier = 1
		local firstTimeUp = true

		task.spawn(function()
			if lerpingCou ~= nil then
				coroutine.close(lerpingCou)
			end
			lerpingCou = lerpCamera(hum.CameraOffset, Vector3.new(0, -3, 0), 0.2)
		end)

		PosCheck = RunService.Heartbeat:Connect(function(deltaTime)
			local CurrentY = RootPart.Position.Y
			local VerticalChange = (CurrentY - PreviousY)
			PreviousY = CurrentY

			local RayDirection = -RootPart.CFrame.UpVector * 10
			local GroundRay = workspace:Raycast(RootPart.Position, RayDirection, Params)

			--// Align Character to the slope
			--[[
			if GroundRay then
				local CurrentRightVector = RootPart.CFrame.RightVector
				local UpVector = GroundRay.Normal
				local NewFacialVector = CurrentRightVector:Cross(UpVector)
				AlignGyro.CFrame = CFrame.fromMatrix(RootPart.Position, CurrentRightVector, UpVector, NewFacialVector)
			end]]
			if dashDir == "W" then
				SlideVelocity.VectorVelocity = RootPart.CFrame.LookVector * (Settings.BaseSpeed * CurrentMultiplier)
			elseif dashDir == "S" then
				SlideVelocity.VectorVelocity = -RootPart.CFrame.LookVector * (Settings.BaseSpeed * CurrentMultiplier)
			elseif dashDir == "D" then
				SlideVelocity.VectorVelocity = RootPart.CFrame.RightVector * (Settings.BaseSpeed * CurrentMultiplier)
			elseif dashDir == "A" then
				SlideVelocity.VectorVelocity = -RootPart.CFrame.RightVector * (Settings.BaseSpeed * CurrentMultiplier)
			end

			if VerticalChange < 0.1 and VerticalChange > -0.1 then -- Slide Forward (decrease speed until 0)
				if CurrentMultiplier > 1 then -- If too fast speed rate will multiply and speed will drop fastur!
					CurrentMultiplier = math.clamp(
						CurrentMultiplier - (Settings.SpeedChangeRate.Forward * 2) * deltaTime,
						0,
						Settings.MaxMultiplier
					)
				end
				CurrentMultiplier = math.clamp(
					CurrentMultiplier - Settings.SpeedChangeRate.Forward * deltaTime,
					0,
					Settings.MaxMultiplier
				)
			elseif VerticalChange > 0 then -- Slide Up (decrease speed until 0)
				if firstTimeUp then
					CurrentMultiplier += 1
					firstTimeUp = false
				end

				if CurrentMultiplier > 1 then -- If too fast speed rate will multiply and speed will drop fastur!
					CurrentMultiplier = math.clamp(
						CurrentMultiplier - (Settings.SpeedChangeRate.Upward * 1.5) * deltaTime,
						0,
						Settings.MaxMultiplier
					)
				end
				CurrentMultiplier = math.clamp(
					CurrentMultiplier - Settings.SpeedChangeRate.Upward * deltaTime,
					0,
					Settings.MaxMultiplier
				)
			else -- Slide Down (Add up speed until max)
				CurrentMultiplier = math.clamp(
					CurrentMultiplier + Settings.SpeedChangeRate.Downward * deltaTime,
					0,
					Settings.MaxMultiplier
				)
				firstTimeUp = false
			end

			CurrentMultiplier = math.clamp(CurrentMultiplier, 0, Settings.MaxMultiplier)
			--script.Slide_Loop.Volume = (BaseSoundVolume * CurrentMultiplier)

			if CurrentMultiplier < 0.1 or not GroundRay then
				StopSlide()
			end
		end)
	elseif Input.KeyCode == Enum.KeyCode.Space and isSliding then
		local CancelMultiplier = CurrentMultiplier + 0.5
		dashSoundEnd:Play()

		StopSlide()

		if Settings.PushOnCancel == true then
			local PushVelocity = Instance.new("LinearVelocity")
			PushVelocity.Parent = RootPart
			PushVelocity.Attachment0 = RootPart.RootAttachment
			PushVelocity.MaxForce = 10000

			if dashDir == "W" then
				PushVelocity.VectorVelocity = (
					RootPart.CFrame.LookVector * (Settings.PushVelocity.Forward * CancelMultiplier)
				) + (RootPart.CFrame.UpVector * Settings.PushVelocity.Up)
			elseif dashDir == "S" then
				PushVelocity.VectorVelocity = (
					-RootPart.CFrame.LookVector * (Settings.PushVelocity.Forward * CancelMultiplier)
				) + (RootPart.CFrame.UpVector * Settings.PushVelocity.Up)
			elseif dashDir == "D" then
				PushVelocity.VectorVelocity = (
					RootPart.CFrame.RightVector * (Settings.PushVelocity.Forward * CancelMultiplier)
				) + (RootPart.CFrame.UpVector * Settings.PushVelocity.Up)
			elseif dashDir == "A" then
				PushVelocity.VectorVelocity = (
					-RootPart.CFrame.RightVector * (Settings.PushVelocity.Forward * CancelMultiplier)
				) + (RootPart.CFrame.UpVector * Settings.PushVelocity.Up)
			end

			Debris:AddItem(PushVelocity, 0.1)
		end
	end
end)

--//Jumping
local jumps = 0
local function ToggleFlying()
	if hum.FloorMaterial == Enum.Material.Air and not isSliding then --Is double jumping
		if jumps >= 1 then
			return
		end

		doubleJumpSound:Play()

		jumps += 1

		hum.WalkSpeed += Settings.WalkSpeedGain

		local GetMoveVector =
			require(player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule")):GetMoveVector()
		local x = GetMoveVector.X
		local z = GetMoveVector.Z

		local PushVelocity = Instance.new("LinearVelocity")
		PushVelocity.Parent = RootPart
		PushVelocity.Attachment0 = RootPart.RootAttachment
		PushVelocity.MaxForce = 30000

		local forwardPush = Settings.JumpVelocity.Forward + hum.WalkSpeed

		if (x == 0 and z == 0) or (z < -0.8) then
			PushVelocity.VectorVelocity = (RootPart.CFrame.LookVector * forwardPush)
				+ (RootPart.CFrame.UpVector * Settings.JumpVelocity.Up)
			--print("W")
		elseif z > 0.8 then
			PushVelocity.VectorVelocity = (-RootPart.CFrame.LookVector * forwardPush)
				+ (RootPart.CFrame.UpVector * Settings.JumpVelocity.Up)
			--print("S")
		elseif x > 0.8 then
			PushVelocity.VectorVelocity = (RootPart.CFrame.RightVector * forwardPush)
				+ (RootPart.CFrame.UpVector * Settings.JumpVelocity.Up)
			--print("D")
		elseif x < -0.8 then
			PushVelocity.VectorVelocity = (-RootPart.CFrame.RightVector * forwardPush)
				+ (RootPart.CFrame.UpVector * Settings.JumpVelocity.Up)
			--print("A")
		end
		Debris:AddItem(PushVelocity, 0.1)

		hum:ChangeState(Enum.HumanoidStateType.Jumping) --Jump
	end
end

hum.StateChanged:connect(function(old, new) --Player landed
	if new == Enum.HumanoidStateType.Landed then
		jumps = 0
		hum.WalkSpeed = Settings.WalkSpeed
	end
end)

--//Input
--PC/Xbox
uis.InputBegan:Connect(function(key, processed)
	if key.KeyCode == Enum.KeyCode.Space or key.KeyCode == Enum.KeyCode.ButtonA then
		ToggleFlying()
	end

	---Boost
	if key.KeyCode == Enum.KeyCode.Q then
		local PushVelocity = Instance.new("LinearVelocity")
		PushVelocity.Parent = RootPart
		PushVelocity.Attachment0 = RootPart.RootAttachment
		PushVelocity.MaxForce = 50000
		PushVelocity.VectorVelocity = (RootPart.CFrame.LookVector * 100) + (RootPart.CFrame.UpVector * 100)
		hum.WalkSpeed += 20
		Debris:AddItem(PushVelocity, 0.1)
	end
end)

--Mobile
local jumpButton
if uis.TouchEnabled then
	pcall(function()
		jumpButton = player
			:WaitForChild("PlayerGui")
			:WaitForChild("TouchGui")
			:WaitForChild("TouchControlFrame")
			:WaitForChild("JumpButton")
	end)
end
if jumpButton ~= nil then
	jumpButton.MouseButton1Down:Connect(ToggleFlying)
end

RunService.RenderStepped:Connect(function()
	if hum.WalkSpeed > Settings.MaxWalkSpeed then
		hum.WalkSpeed = Settings.MaxWalkSpeed
	end
end)

--HEADBOB

--[[
RunService.RenderStepped:Connect(function()
	if hum then
		if hum.MoveDirection.Magnitude > 0 and not isSliding then
			local headBobY = math.sin(tick() * 10) * 0.45
			local bob = Vector3.new(0, headBobY, 0)

			hum.CameraOffset = hum.CameraOffset:Lerp(bob, 0.1)
		elseif not isSliding then
			hum.CameraOffset = hum.CameraOffset:Lerp(Vector3.new(), 0.1)
		end
	end
end)]]
