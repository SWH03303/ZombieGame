local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local assets = rs:WaitForChild("Assets")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local Janitor = require(packages:WaitForChild("Janitor"))

local platformModules = modules:WaitForChild("Platform")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require(modules:WaitForChild("Core"):WaitForChild("Packets"))
local gunBase = require(script.Parent.GunBase) --serviceLoader:GetService("GunBase")
local gunStats = require(script.Parent.GunStats)

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

	self.fireSound = self.janitor:Add(
		require(platformModules:WaitForChild("CloneSound"))(
			assets:WaitForChild("Sounds"):WaitForChild("AK96"):WaitForChild("AK96Fire"),
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

	local cd = 1
	local canuse = true
	self.Ability1 = function()
		if not canuse then
			return
		end

		packets.useAbility:Fire({ hrp.CFrame })
		print("AK96 skill 1 used")

		canuse = false
		task.delay(cd, function()
			canuse = true
		end)
	end

	return self
end

return AK96
