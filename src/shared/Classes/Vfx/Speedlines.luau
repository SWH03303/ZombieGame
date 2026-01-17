local Shared = {}

local runService = game:GetService("RunService")
local rs = game:GetService("ReplicatedStorage")
local assets = rs:WaitForChild("Assets")
local speedlines = assets:WaitForChild("Vfx"):WaitForChild("Speedlines"):Clone() :: Part
local camera = game.Workspace.CurrentCamera
speedlines.Parent = camera

local offset = 10

function Shared.Start(char: Model, rate: number, fov: number)
	--local hum = char.Humanoid
	if not camera then
		return
	end

	local viewportSize = camera.ViewportSize
	local aspectRatio = viewportSize.X / viewportSize.Y
	local rate = rate or 1500
	local fov = fov or 70

	if aspectRatio > 1.5 then
		offset = 10
	else
		offset = 13
	end

	task.spawn(function()
		runService:BindToRenderStep("Speedlines", Enum.RenderPriority.Camera.Value, function()
			speedlines.CFrame = camera.CFrame + camera.CFrame.LookVector * (offset / (camera.FieldOfView / fov))
			speedlines.Attachment.ParticleEmitter.Rate = rate
		end)
	end)
end

function Shared.Stop()
	runService:UnbindFromRenderStep("Speedlines")
	speedlines.Position = speedlines.Position - Vector3.new(0, 100, 0)
end

return Shared
