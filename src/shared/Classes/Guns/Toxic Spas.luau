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

local ToxicSpas = {}
ToxicSpas.__index = ToxicSpas
setmetatable(ToxicSpas, gunBase)

function ToxicSpas.New(char)
	local hum = char:WaitForChild("Humanoid")
	local animator = hum:WaitForChild("Animator")
	local hrp = char:WaitForChild("HumanoidRootPart")
	local player = Players:GetPlayerFromCharacter(char)

	local self = gunBase.New(char)
	local viewModel = gunBase:GetViewModel(script.Name, workspace.Camera)
	local viewModelAnimator = viewModel:WaitForChild("Humanoid"):WaitForChild("Animator")

	self.Name = script.Name
	self.Ammo = 8
	self.MaxAmmo = 8
	self.Capacity = 64
	self.Auto = false
	self.FireRate = 1
	self.ReloadTime = 2.5

	self.canAim = true
	self.aimSmooth = 0.125

	self.debounce = false

	self.fireSound = self.janitor:Add(
		require(platformModules:WaitForChild("CloneSound"))(
			assets:WaitForChild("Sounds"):WaitForChild("Toxic Spas"):WaitForChild("Fire"),
			hrp
		),
		"Destroy"
	)

	self.fireAnim = self.janitor:Add(
		require(platformModules:WaitForChild("CloneAnimation"))(
			"rbxassetid://138438224028806",
			viewModel,
			viewModelAnimator
		),
		"Destroy"
	)

	self.reloadAnim = self.janitor:Add(
		require(platformModules:WaitForChild("CloneAnimation"))(
			"rbxassetid://113494729900105",
			viewModel,
			viewModelAnimator
		),
		"Destroy"
	)

	self.viewmodel = viewModel

	--setmetatable(self, ToxicSpas)

	return self
end

return ToxicSpas
