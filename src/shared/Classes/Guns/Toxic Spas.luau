local rs = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local serviceLoader = require(rs.MyServices:WaitForChild("MyServices"))
local gunBase = require(rs.MyServices.Client.GunBase) --serviceLoader:GetService("GunBase")

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

	newGun.fireSound =
		gunBase["GeneralModules"].CloneSound(game:GetService("ReplicatedStorage").Sounds["Toxic Spas"].Fire, hrp)

	newGun.debounce = false

	newGun.reloadTime = 1.5

	newGun.fireAnim =
		gunBase["GeneralModules"].CloneAnimation("rbxassetid://138438224028806", viewModel, viewModelAnimator)
	newGun.reloadAnim =
		gunBase["GeneralModules"].CloneAnimation("rbxassetid://113494729900105", viewModel, viewModelAnimator)

	newGun.viewmodel = viewModel

	setmetatable(newGun, ToxicSpas)

	return newGun
end

return ToxicSpas
