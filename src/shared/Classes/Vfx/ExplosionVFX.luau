local Explosions = {}

local runService = game:GetService("RunService")
local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local explosionFold = rs:WaitForChild("Assets"):WaitForChild("Vfx"):WaitForChild("Explosion")
local packets = require(shared:WaitForChild("Modules"):WaitForChild("Core"):WaitForChild("Packets"))
local explosion = explosionFold:WaitForChild("Explosion")
local sparklingTrail = explosionFold:WaitForChild("SparklingTrail")

local theme = {
	Explosion = {
		Yellow = {
			Fire = { Color = ColorSequence.new(Color3.fromRGB(255, 117, 36)) },
			Glow = { Color = ColorSequence.new(Color3.fromRGB(255, 139, 61)) },
			Smoke = {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 125, 125)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25)),
				}),
			},
			Sparks = { Color = ColorSequence.new(Color3.fromRGB(255, 158, 93)) },
		},
	},
	SparklingTrail = {
		Yellow = {
			Fire = { Color = ColorSequence.new(Color3.fromRGB(255, 117, 36)) },
			Glow = { Color = ColorSequence.new(Color3.fromRGB(255, 139, 61)) },
			Sparks = { Color = ColorSequence.new(Color3.fromRGB(255, 158, 93)) },
		},
	},
}

local ApplyThemeChange = function(theme, att)
	for name, props in pairs(theme) do
		for propName, val in pairs(props) do
			att[name][propName] = val
		end
	end
end

local renderconn = {}
function Explosions.CreateSparklingTrail(att, themeName)
	if not att:FindFirstChild("SparklingTrail") then
		local clone = sparklingTrail.Attachment:Clone()
		clone.Parent = att
		clone.Name = "SparklingTrail"
		ApplyThemeChange(theme.SparklingTrail[themeName], clone)
	end

	local elapsed = 0
	local WAIT_TIME = 0.03
	renderconn[att] = runService.RenderStepped:Connect(function(dt: number)
		elapsed += dt
		if elapsed >= WAIT_TIME then
			for _, particle in pairs(att.SparklingTrail:GetChildren()) do
				local emitCount = particle:GetAttribute("EmitCount") or 1
				particle:Emit(emitCount)
			end
			elapsed = 0
		end
	end)
end

function Explosions.DisableSparklingTrail(att)
	renderconn[att]:Disconnect()
end

function Explosions.CreateExplosion(pos: Vector3, themeName)
	local clone = explosion:Clone() :: Part
	clone.Position = pos
	clone.Parent = workspace
	ApplyThemeChange(theme.SparklingTrail[themeName], clone.Attachment)

	for _, particle in pairs(clone.Attachment:GetChildren()) do
		local emitCount = particle:GetAttribute("EmitCount") or 1
		particle:Emit(emitCount)
	end
	task.delay(5, function()
		clone:Destroy()
	end)

	return clone
end

packets.vfxRequest.OnClientEvent:Connect(function(vfxName, info)
	print(vfxName)
	if vfxName ~= "SparklingTrail" then
		return
	end

	print(info)
end)

return Explosions
