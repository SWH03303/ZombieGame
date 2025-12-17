local rs = game:GetService("ReplicatedStorage")

local partCacheModule = require(rs:WaitForChild("Packages"):WaitForChild("PartCache"))

local vfx = {}

local bullet = rs:WaitForChild("Assets"):WaitForChild("Vfx"):WaitForChild("Bullet")
local pCache = partCacheModule.new(bullet, 3)
print("initialized")
function vfx:CreateBulletTrail(pos1, pos2)
	task.spawn(function()
		local part = pCache:GetPart()
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

return vfx
