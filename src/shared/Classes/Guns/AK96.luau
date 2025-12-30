local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local assets = rs:WaitForChild("Assets")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local Janitor = require(packages:WaitForChild("Janitor"))

local platformModules = modules:WaitForChild("Platform")

local Players = game:GetService("Players")
local gunBase = require(script.Parent.GunBase) --serviceLoader:GetService("GunBase")

local AK96 = {}
AK96.__index = AK96
setmetatable(AK96, gunBase)

function AK96.New(char)
	local hum = char:WaitForChild("Humanoid")
	local animator = hum:WaitForChild("Animator")
	local hrp = char:WaitForChild("HumanoidRootPart")
	local player = Players:GetPlayerFromCharacter(char)

	local self = gunBase.New(char)
	local viewModel = gunBase:GetViewModel(script.Name, workspace.Camera)
	local viewModelAnimator = viewModel:WaitForChild("Humanoid"):WaitForChild("Animator")

	self.Name = script.Name
	self.Ammo = 30
	self.MaxAmmo = 30
	self.Capacity = 180
	self.Auto = true
	self.FireRate = 0.15
	self.MaxSpread = 3
	self.Damage = 10

	self.canAim = true
	self.aimSmooth = 0.08

	-- self.fireSound = gunBase["GeneralModules"].CloneSound(game:GetService("ReplicatedStorage").Sounds.AK96.Fire, hrp)

	self.debounce = false
	self.reloadTime = 2

	self.fireSound = self.janitor:Add(
		require(platformModules:WaitForChild("CloneSound"))(
			assets:WaitForChild("Sounds"):WaitForChild("AK96"):WaitForChild("Fire"),
			hrp
		),
		"Destroy"
	)

	self.fireAnim = self.janitor:Add(
		require(platformModules:WaitForChild("CloneAnimation"))(
			"rbxassetid://72333481697984",
			viewModel,
			viewModelAnimator
		),
		"Destroy"
	)

	self.reloadAnim = self.janitor:Add(
		require(platformModules:WaitForChild("CloneAnimation"))(
			"rbxassetid://96834634609369",
			viewModel,
			viewModelAnimator
		),
		"Destroy"
	)

	self.viewmodel = viewModel

	return self
end

return AK96
