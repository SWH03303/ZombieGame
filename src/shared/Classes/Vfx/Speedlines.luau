local rs = game:GetService("ReplicatedStorage")
local assets = rs:WaitForChild("Assets")
local speedlinesTemplate = assets:WaitForChild("Vfx"):WaitForChild("Speedlines")
local Shared = {}

function Shared.EnableSpeedlines(char: Model, rate)
	local head = char.Head
	local speedlines = char:FindFirstChild("Speedlines")
	if speedlines == nil then
		local clone = speedlinesTemplate:Clone()
		clone.Parent = char
		clone.CFrame = head.CFrame * CFrame.new(0, 0, -20)
		clone.WeldConstraint.Part0 = head
		speedlines = clone
	end
	speedlines.Attachment.ParticleEmitter.Enabled = true
end

function Shared.DisableSpeedlines(char: Model)
	local speedlines = char:FindFirstChild("Speedlines")
	if speedlines then
		speedlines.Attachment.ParticleEmitter.Enabled = true
	end
end

return Shared
