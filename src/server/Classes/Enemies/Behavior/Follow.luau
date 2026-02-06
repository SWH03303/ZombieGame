local rs = game:GetService("ReplicatedStorage")
local shared = rs.Shared
local players = game:GetService("Players")
local modules = shared.Modules
local hitscan = require(modules.Game.Hitscan)

local followBehavior = {}
followBehavior.__index = followBehavior

export type followBehavior = {
	findElapsed: number,
	moveElapsed: number,
	climbElapsed: number,
	climbing: boolean,
	currentTarget: Model,
	vectorForce: VectorForce,
	char: Model,
}

function followBehavior.new(char: Model)
	local self = setmetatable({}, followBehavior)

	self.findElapsed = 0
	self.moveElapsed = 0
	self.climbElapsed = 0
	self.climbing = false
	self.currentTarget = nil
	self.char = char

	local hrp = self.char.HumanoidRootPart
	local vectorForce = Instance.new("VectorForce")
	vectorForce.Parent = hrp
	vectorForce.Attachment0 = hrp.RootAttachment
	vectorForce.Enabled = true

	self.vectorForce = vectorForce

	return self
end

function followBehavior.Follow(self: followBehavior, dt: number)
	local hrp = self.char.HumanoidRootPart
	local hum = self.char.Humanoid

	self.findElapsed += dt
	if self.findElapsed > 1 then
		local closet = 9999999
		for _, player in pairs(players:GetPlayers()) do
			local playerChar = player.Character
			if playerChar then
				local dis = (hrp.Position - playerChar.HumanoidRootPart.Position).Magnitude
				if dis < closet then
					closet = dis
					self.currentTarget = playerChar
				end
			end
		end
		self.findElapsed = 0
	end

	self.moveElapsed += dt
	if self.currentTarget and self.moveElapsed > 0.1 then
		local dir = (self.currentTarget.HumanoidRootPart.Position - hrp.Position)
		dir = Vector3.new(dir.X, 0, dir.Z).Unit

		hum.AutoRotate = true
		hum:Move(dir, false)
		self.moveElapsed = 0
	end

	self.climbElapsed += dt
	if self.climbElapsed > 0.3 and self.currentTarget then
		local enemyPos = self.currentTarget.HumanoidRootPart.Position
		local flatDir = Vector3.new(enemyPos.X - hrp.Position.X, 0, enemyPos.Z - hrp.Position.Z)
		local direction = flatDir.Unit * 10 --2.3

		local raycastResult = hitscan:CreateRay(hrp.Position, direction, { self.char, self.currentTarget })
		if raycastResult.Instance then
			print("climb")
			self.climbing = true
			self.vectorForce.Force = Vector3.new(0, 50, 0)
		else
			self.climbing = false
			self.vectorForce.Force = Vector3.new(0, 0, 0)
		end

		self.climbElapsed = 0
	end
end

return followBehavior
