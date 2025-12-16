local rs = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local serviceLoader = require(rs.MyServices:WaitForChild("MyServices"))
local gunBase = require(rs.MyServices.Client.GunBase) --serviceLoader:GetService("GunBase")

local Glock = {}
Glock.__index = Glock
setmetatable(Glock, gunBase)

function Glock.New(char)
	local hum = char:WaitForChild("Humanoid")
	local animator = hum:WaitForChild("Animator")
	local hrp = char:WaitForChild("HumanoidRootPart")
	local player = Players:GetPlayerFromCharacter(char)

	local newGun = gunBase.New(char)
	local viewModel = gunBase:GetViewModel(script.Name, workspace.Camera)
	local viewModelAnimator = viewModel:WaitForChild("Humanoid"):WaitForChild("Animator")

	newGun.Name = script.Name
	newGun.Ammo = 17
	newGun.MaxAmmo = 17
	newGun.Capacity = 102
	newGun.Auto = false
	newGun.FireRate = 0.15

	newGun.canAim = true
	newGun.aimSmooth = 0.125

	newGun.fireSound = gunBase["GeneralModules"].CloneSound(game:GetService("ReplicatedStorage").Sounds.Glock.Fire, hrp)

	newGun.debounce = false

	newGun.reloadTime = 1.5

	newGun.fireAnim =
		gunBase["GeneralModules"].CloneAnimation("rbxassetid://124396564823100", viewModel, viewModelAnimator)
	newGun.reloadAnim =
		gunBase["GeneralModules"].CloneAnimation("rbxassetid://91793492884293", viewModel, viewModelAnimator)

	newGun.viewmodel = viewModel

	setmetatable(newGun, Glock)

	return newGun
end

return Glock
