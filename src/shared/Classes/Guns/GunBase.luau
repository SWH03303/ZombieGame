local rs = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local serviceLoader = require(rs.MyServices:WaitForChild("MyServices"))
local RSviewmodelFolder = rs:WaitForChild("Assets"):WaitForChild("ViewModels")

local Gun = {}
Gun.__index = Gun

function Gun:GetViewModel(name, camera)
	local loadedViewmodelFold = rs:FindFirstChild("ViewmodelFoldPlayer")
	if loadedViewmodelFold == nil then
		loadedViewmodelFold = Instance.new("Folder")
		loadedViewmodelFold.Parent = rs
		loadedViewmodelFold.Name = "ViewmodelFoldPlayer"
	end

	local viewmodel

	for i, v in pairs(camera:GetChildren()) do
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

function Gun:Init()
	Gun["GeneralModules"] = serviceLoader:GetService("GeneralModules")
	Gun["Hitscan"] = serviceLoader:GetService("Hitscan")
	Gun["VfxService"] = serviceLoader:GetService("VfxService")

	return true
end

function Gun.New(char)
	local hum = char:WaitForChild("Humanoid")
	local animator = hum:WaitForChild("Animator")
	local hrp = char.HumanoidRootPart
	local player = Players:GetPlayerFromCharacter(char)

	local newGun = {}

	newGun.Name = "Gun"
	local viewModel = Gun:GetViewModel("Gun", workspace.Camera)
	newGun.Damage = 10
	newGun.Auto = false
	newGun.Ammo = 10
	newGun.MaxAmmo = 10
	newGun.Capacity = 100
	newGun.FireRate = 0.15
	newGun.ReloadTime = 2.5
	newGun.MaxSpread = 3

	newGun.aimSmooth = 0.125

	newGun.debounce = false

	newGun.fireSound = Gun["GeneralModules"].CloneSound(game:GetService("ReplicatedStorage").Sounds.Glock.Fire, hrp)

	newGun.canAim = true
	newGun.isReloading = false
	newGun.canShoot = true
	newGun.isShooting = false
	newGun.isAiming = false

	newGun.fireAnim = Gun["GeneralModules"].CloneAnimation("rbxassetid://124396564823100", viewModel, animator)
	newGun.reloadAnim = Gun["GeneralModules"].CloneAnimation("rbxassetid://91793492884293", viewModel, animator)

	newGun.char = char
	newGun.viewmodel = viewModel
	--print(viewModel)

	newGun.camera = workspace.Camera
	newGun.normalswayAMT = 0.7
	newGun.aimswayAmount = 0.2
	newGun.currAimsway = 0
	newGun.swayCF = CFrame.new()
	newGun.lastCameraCF = CFrame.new()
	newGun.aimCF = CFrame.new()

	newGun.hud = player.PlayerGui:WaitForChild("HUD")

	newGun.char = char
	newGun.hum = hum

	setmetatable(newGun, Gun)
	return newGun
end

local random = Random.new()

function Gun:Shoot()
	local function createRayAndShoot()
		local rayOrigin = self.char.Head.Position
		local rayDirection = (self.camera.CFrame * CFrame.Angles(
			random:NextNumber(-0.01, 0.01),
			random:NextNumber(-0.01, 0.01),
			0
		)).LookVector * 500
		local filter = { self.char }
		local attPos = self.viewmodel.GunTipAtt.Value.WorldPosition
		local hitscan = Gun["Hitscan"]:CreateRay(rayOrigin, rayDirection, filter)
		--print(hitscan)
		Gun["VfxService"]:CreateBulletTrail(attPos, hitscan.Position)
	end

	if self.Auto == false and not self.isReloading and self.canShoot and not self.debounce and self.Ammo > 0 then
		self.fireAnim:Play(0)
		self.Ammo -= 1
		self.fireSound:Play()

		createRayAndShoot()

		task.spawn(function()
			self.debounce = true
			task.wait(self.FireRate)
			self.debounce = false
		end)
	end

	if self.Auto and not self.isShooting and not self.isReloading and self.canShoot and not self.debounce then
		self.isShooting = true

		task.spawn(function()
			self.debounce = true
			task.wait(self.FireRate)
			self.debounce = false
		end)

		task.spawn(function()
			while self.isShooting and self.Ammo > 0 and self.canShoot do
				self.fireAnim:Play(0)
				self.fireSound:Play()
				self.Ammo -= 1

				createRayAndShoot()

				task.wait(self.FireRate)
			end
		end)
	end
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

function Gun:RenderWork()
	local rot = self.camera.CFrame:ToObjectSpace(self.lastCameraCF)
	local x, y, z = rot:ToOrientation()
	self.swayCF =
		self.swayCF:Lerp(CFrame.Angles(math.sin(x) * self.currAimsway, math.sin(y) * self.currAimsway, 0), 0.1)
	self.lastCameraCF = self.camera.CFrame

	if self.viewmodel then
		self.hud.GunName.Text = self.Name
		self.hud.Ammo.Text = self.Ammo
		self.hud.Ammo.MaxAmmo.Text = self.Capacity
	end

	for i, v in pairs(self.camera:GetChildren()) do
		if v:IsA("Model") then
			v:SetPrimaryPartCFrame(self.camera.CFrame * self.swayCF * self.aimCF)
		end
	end

	if self.isAiming and self.viewmodel ~= nil and self.canAim then
		local offset = self.viewmodel.AimPart.CFrame:ToObjectSpace(self.viewmodel.PrimaryPart.CFrame)
		self.aimCF = self.aimCF:Lerp(offset, self.aimSmooth)
		self.currAimsway = self.aimswayAmount
	else
		local offset = CFrame.new()
		self.aimCF = self.aimCF:Lerp(offset, self.aimSmooth)
		self.currAimsway = self.normalswayAMT
	end
end

return Gun
