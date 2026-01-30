local rs = game:GetService("ReplicatedStorage")
local partCacheModule = require(rs:WaitForChild("Packages"):WaitForChild("PartCache"))
local bullet = rs:WaitForChild("Assets"):WaitForChild("Vfx"):WaitForChild("Bullet")
local pCache = partCacheModule.new(bullet, 2, workspace.Projectiles)
local packet = require(rs:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Core"):WaitForChild("Packets"))
--print("create bullets")

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

function CreateBulletTrail(pos1: Vector3, pos2: Vector3, themeName: string, travelTime: number?)
	task.spawn(function()
		local part = pCache:GetPart()
		ApplyThemeChange(theme[themeName], part)
		part.Position = pos1
		part.Trail.Enabled = true
		part.Parent = workspace
		local bulletTravelTime = travelTime or 0.01
		task.wait(bulletTravelTime)
		part.Position = pos2

		task.wait(0.1)
		part.Trail.Enabled = false
		pCache:ReturnPart(part)
	end)

	return
end

export type BulletVfxInfo = {
	originPos: Vector3,
	goalPos: Vector3,
	theme: string,
	shooter: Player,
}
packet.vfxRequest.OnClientEvent:Connect(function(vfxName: string, info: BulletVfxInfo)
	if vfxName == "BulletVFX" and info.shooter ~= game:GetService("Players").LocalPlayer then
		CreateBulletTrail(info.originPos, info.goalPos, info.theme, 0.1)
		print("create bullet")
	end
end)

return CreateBulletTrail
