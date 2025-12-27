--!strict
local gunServiceClient = {}

local player = game:GetService("Players").LocalPlayer

local rs = game:GetService("ReplicatedStorage")
local rf = game:GetService("ReplicatedFirst")
local packages = rs:WaitForChild("Packages")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Janitor = require(packages:WaitForChild("Janitor"))
local janitor = Janitor.new()

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

function createGuns(char: Model)
	for i = 1, 3 do
		module = require(GunClassFold:WaitForChild(inventory[i]))
		loadedGun[inventory[i]] = module.New(char)
		--janitor:Add(loadedGun[inventory[i]])
	end
end

function loadSlot(Item)
	if gun then
		gun.canShoot = false
		gun.viewmodel.Parent = rf:WaitForChild("ViewmodelFoldPlayer")
	end

	gun = loadedGun[Item]
	gun.viewmodel.Parent = camera
	gun.canShoot = true
end

player.CharacterAdded:Connect(function(char)
	print("nig")
	local hum = char:WaitForChild("Humanoid")

	createGuns(char)
	loadSlot(inventory[1])

	janitor:Add(
		RunService.RenderStepped:Connect(function()
			if gun then
				gun:RenderWork()
			end
		end),
		"Disconnect"
	)

	janitor:Add(
		UserInputService.InputBegan:Connect(function(input, IsTyping)
			local function load(num)
				loadSlot(inventory[num])
				currentSlot = num
				gun.aimCF = CFrame.new()
			end

			if IsTyping then
				return
			end

			if input.KeyCode == Enum.KeyCode.One then
				if currentSlot ~= 1 and gun ~= nil and gun.isReloading == false then
					load(1)
				end
			end

			if input.KeyCode == Enum.KeyCode.Two then
				if currentSlot ~= 2 and gun ~= nil and gun.isReloading == false then
					load(2)
				end
			end

			if input.KeyCode == Enum.KeyCode.Three then
				if currentSlot ~= 3 and gun ~= nil and gun.isReloading == false then
					load(3)
				end
			end

			if input.KeyCode == Enum.KeyCode.Four then
				if currentSlot ~= 4 and gun ~= nil and gun.isReloading == false then
					load(4)
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
		end),
		"Disconnect"
	)

	janitor:Add(
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton2 and gun ~= nil then
				gun.isAiming = false
			end

			if input.UserInputType == Enum.UserInputType.MouseButton1 and gun ~= nil then
				gun.isShooting = false
			end
		end),
		"Disconnect"
	)

	janitor:Add(
		hum.Died:Connect(function()
			janitor:CleanUp()
			loadedGun = {}
		end),
		"Disconnect"
	)
end)

return gunServiceClient
