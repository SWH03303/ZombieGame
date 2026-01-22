--!strict
local movementService = {}

local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local movementClass = shared:WaitForChild("Classes"):WaitForChild("Movement")
local modules = shared:WaitForChild("Modules")
local packets = require(modules:WaitForChild("Core"):WaitForChild("Packets"))
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
	MaxSpeed = 80,
	MaxFallSpeed = -40,
}

local rawSpeed = playerStats.WalkSpeed
local airSpeed = 0

local function updateSpeed(hum: Humanoid)
	if rawSpeed + airSpeed > HiddenStats.MaxSpeed then
		hum.WalkSpeed = HiddenStats.MaxSpeed
	else
		hum.WalkSpeed = rawSpeed + airSpeed
	end
end
function movementService.AddSpeed(char: Model, value: number, duration: number, airBoost: boolean)
	local hum = char.Humanoid :: Humanoid

	if hum then
		if airBoost then
			if hum.FloorMaterial == Enum.Material.Air then
				airSpeed += value
				updateSpeed(hum)
			else
				task.delay(0.1, function()
					if hum.FloorMaterial == Enum.Material.Air then
						airSpeed += value
						updateSpeed(hum)
					end
				end)
			end
		else
			rawSpeed += value
			updateSpeed(hum)
			task.delay(duration, function()
				rawSpeed -= value
				updateSpeed(hum)
			end)
		end
	end
end

packets.addSpeed.OnClientEvent:Connect(function(speed, duration, airboost)
	local char = player.Character
	if char then
		movementService.AddSpeed(char, speed, duration, airboost)
	end
end)

local function onCharacterAdded(char: Model)
	if char == nil then
		return
	end
	local hum = char.Humanoid :: Humanoid
	for stat, val in playerStats do
		hum[stat] = val
	end
	local hrp = char:WaitForChild("HumanoidRootPart") :: Part

	local vectorForce = Instance.new("VectorForce", hrp)
	vectorForce.Attachment0 = hrp.RootAttachment
	vectorForce.Enabled = true
	vectorForce.Force = Vector3.new(0, gravityVector * hrp.AssemblyMass * 0.5, 0)
	janitor:Add(
		runService.RenderStepped:Connect(function(dt)
			local vel = hrp.AssemblyLinearVelocity
			local y = vel.Y
			local SMOOTH = -HiddenStats.MaxFallSpeed
			if y < HiddenStats.MaxFallSpeed then
				local targetY = HiddenStats.MaxFallSpeed
				local newY = y + (targetY - y) * math.clamp(SMOOTH * dt, 0, 1)
				hrp.AssemblyLinearVelocity =
					Vector3.new(hrp.AssemblyLinearVelocity.X, newY, hrp.AssemblyLinearVelocity.Z)
			end
		end),
		"Disconnect"
	)

	local dash = require(movementClass:WaitForChild("Dash"))
	dash.CoolDown = 1

	janitor:Add(hum:GetPropertyChangedSignal("FloorMaterial"):Connect(function(material)
		if material ~= Enum.Material.Air then
			airSpeed = 0
			updateSpeed(hum)
		end
	end))

	hum.Died:Once(function()
		janitor:Cleanup()
	end)
end
onCharacterAdded(player.Character)
player.CharacterAdded:Connect(onCharacterAdded)

return movementService
