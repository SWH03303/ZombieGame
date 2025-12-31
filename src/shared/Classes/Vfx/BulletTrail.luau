local rs = game:GetService("ReplicatedStorage")
local partCacheModule = require(rs:WaitForChild("Packages"):WaitForChild("PartCache"))
local bullet = rs:WaitForChild("Assets"):WaitForChild("Vfx"):WaitForChild("Bullet")
local pCache = partCacheModule.new(bullet, 3)

local theme = {
	Yellow = {
		Trail = {
			Color = ColorSequence.new(Color3.fromRGB(255, 255, 0)),
		},
	},
	Green = {
		Trail = {
			Color = ColorSequence.new(Color3.fromRGB(17, 202, 0)),
		},
	},
}

local ApplyThemeChange = function(themeFold, part)
	part.Trail.Color = themeFold.Trail.Color
end

function CreateBulletTrail(pos1: Vector3, pos2: Vector3, themeName: string)
	task.spawn(function()
		local part = pCache:GetPart()
		ApplyThemeChange(theme[themeName], part)
		part.Position = pos1
		part.Trail.Enabled = true
		part.Parent = workspace
		task.wait(0.001)
		part.Position = pos2

		task.wait(0.1)
		part.Trail.Enabled = false
		pCache:ReturnPart(part)
	end)

	return
end

return CreateBulletTrail
