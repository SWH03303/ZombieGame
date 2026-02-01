local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local assets = rs:WaitForChild("Assets")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local Janitor = require(packages:WaitForChild("Janitor"))
local partCacheModule = require(packages:WaitForChild("PartCache"))

local platformModules = modules:WaitForChild("Platform")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require(modules:WaitForChild("Core"):WaitForChild("Packets"))
local gunBase = require(script.Parent.GunBase) --serviceLoader:GetService("GunBase")
local gunStats = require(script.Parent.GunStats)
local projectile = require(shared:WaitForChild("Classes"):WaitForChild("Attacks"):WaitForChild("Projectile"))
local explosionVFX = require(shared:WaitForChild("Classes"):WaitForChild("Vfx"):WaitForChild("ExplosionVFX"))

local AK96 = {}
AK96.__index = AK96
setmetatable(AK96, gunBase)

function AK96.New(char): typeof(AK96)
	local hum = char:WaitForChild("Humanoid")
	local animator = hum:WaitForChild("Animator")
	local hrp = char:WaitForChild("HumanoidRootPart") :: Part
	local player = Players:GetPlayerFromCharacter(char)

	local self = gunBase.New(char)
	local viewModel = gunBase:GetViewModel(script.Name, workspace.Camera)
	local viewModelAnimator = viewModel:WaitForChild("Humanoid"):WaitForChild("Animator")

	for statName, value in pairs(gunStats.AK96) do
		self[statName] = value
	end

	self.canAim = true
	self.aimSmooth = 0.08

	-- self.fireSound = gunBase["GeneralModules"].CloneSound(game:GetService("ReplicatedStorage").Sounds.AK96.Fire, hrp)

	self.debounce = false

	self.fireSound = require(platformModules:WaitForChild("CloneSound"))(
		assets:WaitForChild("Sounds"):WaitForChild("AK96"):WaitForChild("AK96Fire"),
		hrp
	)

	self.fireAnim = require(platformModules:WaitForChild("CloneAnimation"))(
		"rbxassetid://72333481697984",
		viewModel,
		viewModelAnimator
	)

	self.ability1ShootSound = require(platformModules:WaitForChild("CloneSound"))(
		assets:WaitForChild("Sounds"):WaitForChild("AK96"):WaitForChild("MollyShootSound"),
		hrp
	)

	self.reloadAnim = require(platformModules:WaitForChild("CloneAnimation"))(
		"rbxassetid://96834634609369",
		viewModel,
		viewModelAnimator
	)

	self.viewmodel = viewModel

	local cd = self.Ability1CD
	local canuse = true
	self.Ability1GunSpecific = function()
		if not canuse then
			return
		end

		self.fireAnim:Play(0)
		self.ability1ShootSound:Play()
		local pos = self.viewmodel.Launcher.Attachment.WorldPosition
		packets.useAbility:Fire({
			name = "AK96Ability1",
			position = pos,
			direction = self.camera.CFrame.LookVector,
			power = 75,
		})

		canuse = false
		task.delay(cd, function()
			canuse = true
		end)
	end

	return self
end

local caster = nil
local ball = assets:WaitForChild("Projectiles"):WaitForChild("Ball")
local pCache = partCacheModule.new(ball, 2, workspace.Projectiles)
packets.useAbility.OnClientEvent:Connect(function(info)
	if info.name ~= "AK96Ability1" then
		return
	end
	local player = Players.LocalPlayer
	local char = player.Character
	local emiter = nil

	if caster == nil then
		local function onHit(bullet: Part)
			for _, p in pairs(pCache.InUse) do
				if p == bullet then
					explosionVFX.DisableSparklingTrail(bullet.Attachment)
					local explosion = explosionVFX.CreateExplosion(bullet.Position, "Yellow")
					local explosionSound = require(platformModules:WaitForChild("CloneSound"))(
						assets:WaitForChild("Sounds"):WaitForChild("AK96"):WaitForChild("ExplosionSound"),
						explosion
					)
					explosionSound:Play()
					pCache:ReturnPart(bullet)
					return
				end
			end
			return
		end
		caster = projectile.NewSimpleCaster(onHit, pCache, 250, Vector3.new(0, -50, 0), workspace.Projectiles, { char })
	end

	projectile.Fire(caster, info.position, info.direction, info.power)
	caster.caster.LengthChanged:Once(function(_, _, _, _, _, cosmeticBulletObject: Instance)
		explosionVFX.CreateSparklingTrail(cosmeticBulletObject.Attachment, "Yellow")
	end)
end)

return AK96
