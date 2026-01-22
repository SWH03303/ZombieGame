local Explosions = {}

local rs = game:GetService("ReplicatedStorage")
local explosionFold = rs:WaitForChild("Assets"):WaitForChild("Vfx"):WaitForChild("Explosion")

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

function Explosions.CreateSparklingTrail(att, themeName)
	if not att:FindFirstChild("SparklingTrail") then
		local clone = sparklingTrail.Attachment:Clone()
		clone.Parent = att
		ApplyThemeChange(theme.SparklingTrail[themeName], clone)
	end

	for _, particle in pairs(att.SparklingTrail:GetChildren()) do
		local emitCount = particle:GetAttribute("EmitCount") or 1
		particle:Emit(emitCount)
	end
end

return Explosions
