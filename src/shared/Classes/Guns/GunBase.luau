local rs = game:GetService("ReplicatedStorage")
local rf = game:GetService("ReplicatedFirst")
local packages = rs:WaitForChild("Packages")
local assets = rs:WaitForChild("Assets")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RSviewmodelFolder = rs:WaitForChild("Assets"):WaitForChild("ViewModels")
local platformModules = modules:WaitForChild("Platform")
local gameModules = modules:WaitForChild("Game")
local VfxServiceClient = require(ReplicatedStorage.Shared.Services.VfxService.VfxServiceClient)
local Janitor = require(packages:WaitForChild("Janitor"))
local playerDataService = services:WaitForChild("PlayerDataService")
local VfxService = require(services:WaitForChild("VfxService"):WaitForChild("VfxServiceClient"))
local hudUI = require(shared:WaitForChild("UI"):WaitForChild("HUD"):WaitForChild("HUDhandler"))

local Gun = {}
Gun.__index = Gun

local packet = require(modules:WaitForChild("Core"):WaitForChild("Packets"))
local janitor = Janitor.new()
local playerSettings = require(playerDataService:WaitForChild("PlayerDataServiceClient")).playerSettingsData

function Gun:Init()
	--
	return true
end

local camera = game.Workspace.CurrentCamera
local originalFOV = playerSettings.fieldOfView
local cameraZoomEffect = playerSettings.cameraZoomEffect
local hideMuzzle = playerSettings.hideMuzzle
camera.FieldOfView = originalFOV
janitor:Add(
	packet.updateSettingsAlert.OnClientEvent:Connect(function()
		camera.FieldOfView = playerSettings.fieldOfView
		originalFOV = playerSettings.fieldOfView
		cameraZoomEffect = playerSettings.cameraZoomEffect
		hideMuzzle = playerSettings.hideMuzzle
	end),
	"Disconnect"
)

function Gun:GetViewModel(name, camera)
	local loadedViewmodelFold = rf:WaitForChild("ViewmodelFoldPlayer")

	local viewmodel

	for _, v in pairs(camera:GetChildren()) do
		if v:IsA("Model") then
			v.Parent = loadedViewmodelFold
		end
	end

	if loadedViewmodelFold:FindFirstChild(name) then
		viewmodel = loadedViewmodelFold[name]
		viewmodel.Parent = camera

		return viewmodel
	end

	if RSviewmodelFolder:FindFirstChild(name) then
		viewmodel = RSviewmodelFolder:FindFirstChild(name):Clone()
		viewmodel.Parent = camera

		return viewmodel
	end
	return
end

function Gun.New(char)
	local hum = char:WaitForChild("Humanoid")
	local hrp = char.HumanoidRootPart
	local player = Players:GetPlayerFromCharacter(char)
	local self = setmetatable({}, Gun)

	self.janitor = Janitor.new()
	self.Name = "Gun"

	local viewModel = Gun:GetViewModel("Gun", workspace.Camera)

	self.Damage = 10
	self.CritDamage = 15
	self.Auto = false
	self.Burst = 0
	self.BurstDelay = 0
	self.MultiShot = 1
	self.Ammo = 10
	self.MaxAmmo = 10
	self.Capacity = 100
	self.FireRate = 0.15
	self.ReloadTime = 2
	self.Spread = 0.02
	self.AimSpread = 0.01
	self.ADSmultiplier = 1.5
	self.BulletTheme = "Yellow"

	self.debounce = false
	self.fireSound = nil

	self.canAim = true
	self.isReloading = false
	self.canShoot = true
	self.isShooting = false
	self.isAiming = false

	self.fireAnim = nil
	self.reloadAnim = nil

	self.char = char
	self.viewmodel = viewModel

	self.camera = workspace.Camera
	self.normalswayAMT = 2
	self.aimswayAmount = 0.2
	self.currAimsway = 0
	self.swayCF = CFrame.new()
	self.lastCameraCF = CFrame.new()
	self.aimCF = CFrame.new()
	self.aimSmooth = 0.125
	self.zoomInElapsed = 0
	self.zoomOutElapsed = self.aimSmooth

	self.hud = player.PlayerGui:WaitForChild("HUD")

	self.hum = hum

	return self
end

local random = Random.new()

function Gun:Shoot()
	hudUI.HitMarker()

	local function createRayAndShoot()
		local spread
		if self.isAiming then
			spread = self.AimSpread
		else
			spread = self.Spread
		end

		local rayOrigin = self.char.Head.Position
		local rayDirection = (self.camera.CFrame * CFrame.Angles(
			random:NextNumber(-spread, spread),
			random:NextNumber(-spread, spread),
			0
		)).LookVector * 500
		local filter = { self.char }
		local attPos = self.viewmodel.GunTipAtt.Value.WorldPosition
		local hitscan = require(gameModules.Hitscan):CreateRay(rayOrigin, rayDirection, filter)
		local hit = hitscan.Instance
		if hit and hit.Parent:FindFirstChild("Humanoid") then
			task.spawn(function()
				local damageDealt = packet.shoot:Fire(self.char, hit.Parent, hit.Name, self.Name)
				--print(`{self.char.Name} shot {hit.Parent.Name} in the {hit.Name} dealing {damageDealt} HP`)
			end)
		end
		VfxService.CreateBulletTrail(attPos, hitscan.Position, self.BulletTheme)
	end

	if self.isReloading or not self.canShoot or self.debounce or self.Ammo <= 0 then
		return
	end

	self.debounce = true
	task.delay(self.FireRate, function()
		self.debounce = false
	end)

	--------SEMI
	if not self.Auto then
		if not hideMuzzle then
			VfxServiceClient.CreateGunMuzzle(self.viewmodel.GunTipAtt.Value, self.BulletTheme)
		end

		self.fireAnim:Play(0)
		self.Ammo -= 1
		self.fireSound:Play()
		for _ = 1, self.MultiShot do
			task.spawn(function()
				createRayAndShoot()
			end)
		end
		return
	end

	--------AUTO
	if self.isShooting then
		return
	end
	self.isShooting = true
	task.spawn(function()
		while self.isShooting and self.Ammo > 0 and self.canShoot do
			if not hideMuzzle then
				VfxServiceClient.CreateGunMuzzle(self.viewmodel.GunTipAtt.Value, self.BulletTheme)
			end

			self.fireAnim:Play(0)
			self.fireSound:Play()
			self.Ammo -= 1

			createRayAndShoot()

			task.wait(self.FireRate)
		end
		self.isShooting = false
	end)
end

function Gun:Reload()
	if self.Capacity > 0 and not self.isReloading then
		self.canShoot = false
		self.isReloading = true

		local reduceAmount = self.MaxAmmo - self.Ammo

		self.reloadAnim:Play(0)
		self.reloadAnim:AdjustSpeed(self.reloadAnim.Length / self.ReloadTime)

		task.wait(self.ReloadTime)

		self.canShoot = true
		self.isReloading = false

		if self.Capacity < reduceAmount then
			self.Ammo += self.Capacity
			self.Capacity = 0
		else
			self.Ammo += reduceAmount
			self.Capacity -= reduceAmount
		end
	end
end

function Gun:RenderWork(dt)
	local function lerp(num, goal, i)
		return num + (goal - num) * i
	end

	local rot = self.camera.CFrame:ToObjectSpace(self.lastCameraCF)
	local x, y, z = rot:ToOrientation()
	self.swayCF =
		self.swayCF:Lerp(CFrame.Angles(math.sin(x) * self.currAimsway, math.sin(y) * self.currAimsway, 0), 0.1)
	self.lastCameraCF = self.camera.CFrame

	if self.viewmodel then
		hudUI.Content.gunName:set(self.Name)
		hudUI.Content.ammo:set(self.Ammo)
		hudUI.Content.maxAmmo:set(self.Capacity)
	end

	for _, v in pairs(self.camera:GetChildren()) do
		if v:IsA("Model") then
			v:SetPrimaryPartCFrame(self.camera.CFrame * self.swayCF * self.aimCF)
		end
	end

	if self.isAiming and self.viewmodel ~= nil and self.canAim then
		local offset = self.viewmodel.AimPart.CFrame:ToObjectSpace(self.viewmodel.PrimaryPart.CFrame)
		self.aimCF = self.aimCF:Lerp(offset, self.aimSmooth)
		self.currAimsway = self.aimswayAmount
		camera.FieldOfView = lerp(
			camera.FieldOfView,
			originalFOV / (1 + (self.ADSmultiplier - 1) * (cameraZoomEffect / 100)),
			self.aimSmooth
		)
	else
		local offset = CFrame.new()
		self.aimCF = self.aimCF:Lerp(offset, self.aimSmooth)
		self.currAimsway = self.normalswayAMT
		if originalFOV ~= camera.FieldOfView then
			camera.FieldOfView = lerp(camera.FieldOfView, originalFOV, self.aimSmooth)
		end
	end
end

function Gun:Destroy()
	self.janitor:Cleanup()
	--print(self.Name)
end

return Gun
