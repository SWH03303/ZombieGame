local gunServiceClient = {}

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local rs = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local GunClassFold = rs:WaitForChild("Shared"):WaitForChild("Classes"):WaitForChild("Guns")

local camera = game.Workspace.CurrentCamera
camera.FieldOfView = 70 ---------------------FOV

local inventory = {
	"AK96",
	"Glock",
	"Toxic Spas",
	"Frag",
}

local loadedGun = {}

local module = nil
local gun = nil
local currentSlot = 1
local viewmodel = nil

--print(workspace.Camera.CFrame)

function createGuns()
	if gun then
		gun.canShoot = false
	end
	for i = 1, 1 do
		module = require(GunClassFold:WaitForChild(inventory[i]))
		gun = module.New(character)
		loadedGun[inventory[i]] = gun
	end

	print(loadedGun)
end

function loadSlot(Item)
	if gun then
		gun.canShoot = false
		gun.viewmodel.Parent = rs:WaitForChild("ViewmodelFoldPlayer")
	end

	gun = loadedGun[Item]
	gun.viewmodel.Parent = camera
	gun.canShoot = true
end

local hud = player.PlayerGui:WaitForChild("HUD")

RunService.RenderStepped:Connect(function()
	if gun then
		gun:RenderWork()
	end
end)

createGuns()
loadSlot(inventory[1])

UserInputService.InputBegan:Connect(function(input, IsTyping)
	if IsTyping then
		return
	end

	if input.KeyCode == Enum.KeyCode.One then
		if currentSlot ~= 1 and gun ~= nil and gun.isReloading == false then
			--print("change")
			loadSlot(inventory[1])
			currentSlot = 1
			gun.aimCF = CFrame.new()
		end
	end

	if input.KeyCode == Enum.KeyCode.Two then
		if currentSlot ~= 2 and gun ~= nil and gun.isReloading == false then
			--print("change")
			loadSlot(inventory[2])
			currentSlot = 2
			gun.aimCF = CFrame.new()
		end
	end

	if input.KeyCode == Enum.KeyCode.Three then
		if currentSlot ~= 3 and gun ~= nil and gun.isReloading == false then
			loadSlot(inventory[3])
			currentSlot = 3
			gun.aimCF = CFrame.new()
		end
	end

	if input.KeyCode == Enum.KeyCode.Four then
		if currentSlot ~= 4 and gun ~= nil and gun.isReloading == false then
			loadSlot(inventory[4])
			currentSlot = 4
			gun.aimCF = CFrame.new()
		end
	end

	if input.UserInputType == Enum.UserInputType.MouseButton2 and gun ~= nil then
		gun.isAiming = true
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 and gun ~= nil then
		gun:Shoot()
	end

	if input.KeyCode == Enum.KeyCode.R and gun ~= nil then
		task.spawn(function()
			gun:Reload()
		end)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 and gun ~= nil then
		gun.isAiming = false
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 and gun ~= nil then
		gun.isShooting = false
	end
end)

return gunServiceClient
