local rs = game:GetService("ReplicatedStorage")
local assets = rs:WaitForChild("Assets")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")

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

	local newGun = gunBase.New(char)
	local viewModel = gunBase:GetViewModel(script.Name, workspace.Camera)
	local viewModelAnimator = viewModel:WaitForChild("Humanoid"):WaitForChild("Animator")

	newGun.Name = script.Name
	newGun.Ammo = 8
	newGun.MaxAmmo = 8
	newGun.Capacity = 64
	newGun.Auto = false
	newGun.FireRate = 1

	newGun.canAim = true
	newGun.aimSmooth = 0.125

	newGun.debounce = false

	newGun.reloadTime = 1.5

	newGun.fireSound = require(platformModules:WaitForChild("CloneSound"))(
		assets:WaitForChild("Sounds"):WaitForChild("Toxic Spas"):WaitForChild("Fire"),
		hrp
	)
	newGun.fireAnim = require(platformModules:WaitForChild("CloneAnimation"))(
		"rbxassetid://138438224028806",
		viewModel,
		viewModelAnimator
	)
	newGun.reloadAnim = require(platformModules:WaitForChild("CloneAnimation"))(
		"rbxassetid://113494729900105",
		viewModel,
		viewModelAnimator
	)

	newGun.viewmodel = viewModel

	setmetatable(newGun, ToxicSpas)

	return newGun
end

return ToxicSpas
