local rs = game:GetService("ReplicatedStorage")
local assets = rs:WaitForChild("Assets")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")

local platformModules = modules:WaitForChild("Platform")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local gunBase = require(script.Parent.GunBase) --serviceLoader:GetService("GunBase")
local gunStats = require(script.Parent.GunStats)

local Glock = {}
Glock.__index = Glock
setmetatable(Glock, gunBase)

function Glock.New(char)
	local hum = char:WaitForChild("Humanoid")
	local animator = hum:WaitForChild("Animator")
	local hrp = char:WaitForChild("HumanoidRootPart")
	local player = Players:GetPlayerFromCharacter(char)

	local self = gunBase.New(char)
	local viewModel = gunBase:GetViewModel(script.Name, workspace.Camera)
	local viewModelAnimator = viewModel:WaitForChild("Humanoid"):WaitForChild("Animator")

	for statName, value in pairs(gunStats.Glock) do
		self[statName] = value
	end

	self.canAim = true
	self.aimSmooth = 0.125

	self.debounce = false

	self.fireSound = self.janitor:Add(
		require(platformModules:WaitForChild("CloneSound"))(
			assets:WaitForChild("Sounds"):WaitForChild("Glock"):WaitForChild("Fire"),
			hrp
		),
		"Destroy"
	)

	self.fireAnim = self.janitor:Add(
		require(platformModules:WaitForChild("CloneAnimation"))(
			"rbxassetid://124396564823100",
			viewModel,
			viewModelAnimator
		),
		"Destroy"
	)

	self.reloadAnim = self.janitor:Add(
		require(platformModules:WaitForChild("CloneAnimation"))(
			"rbxassetid://136725233403611",
			viewModel,
			viewModelAnimator
		),
		"Destroy"
	)

	self.viewmodel = viewModel
	--setmetatable(self, Glock)

	return self
end

return Glock
