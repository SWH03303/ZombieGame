local rs = game:GetService("ReplicatedStorage")
local assets = rs:WaitForChild("Assets")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")

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

	local newAK96 = gunBase.New(char)
	local viewModel = gunBase:GetViewModel(script.Name, workspace.Camera)
	local viewModelAnimator = viewModel:WaitForChild("Humanoid"):WaitForChild("Animator")

	newAK96.Name = script.Name
	newAK96.Ammo = 30
	newAK96.MaxAmmo = 30
	newAK96.Capacity = 180
	newAK96.Auto = true
	newAK96.FireRate = 0.15
	newAK96.MaxSpread = 3
	newAK96.Damage = 10

	newAK96.canAim = true
	newAK96.aimSmooth = 0.08

	--newAK96.fireSound = gunBase["GeneralModules"].CloneSound(game:GetService("ReplicatedStorage").Sounds.AK96.Fire, hrp)
	--print(gunBase["GeneralModules"].CloneSound(game:GetService("ReplicatedStorage").Sounds.AK96.Fire, hrp))

	newAK96.debounce = false

	newAK96.reloadTime = 2

	newAK96.fireAnim = require(platformModules:WaitForChild("CloneAnimation"))(
		"rbxassetid://72333481697984",
		viewModel,
		viewModelAnimator
	)
	newAK96.reloadAnim = require(platformModules:WaitForChild("CloneAnimation"))(
		"rbxassetid://91793492884293",
		viewModel,
		viewModelAnimator
	)

	newAK96.viewmodel = viewModel

	setmetatable(newAK96, AK96)

	return newAK96
end

return AK96
