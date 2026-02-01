--!strict
local gunServiceClient = {}

local player = game:GetService("Players").LocalPlayer

local rs = game:GetService("ReplicatedStorage")
local rf = game:GetService("ReplicatedFirst")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local player = game:GetService("Players").LocalPlayer
local playerDataService = services:WaitForChild("PlayerDataService")
local packages = rs:WaitForChild("Packages")
local UserInputService = game:GetService("UserInputService")
local keybindModule = require(modules:WaitForChild("Game"):WaitForChild("Keybind"))
local RunService = game:GetService("RunService")
local Janitor = require(packages:WaitForChild("Janitor"))
local janitor = Janitor.new()

local playerSettings = require(playerDataService:WaitForChild("PlayerDataServiceClient")).playerSettingsData
local GunClassFold = rs:WaitForChild("Shared"):WaitForChild("Classes"):WaitForChild("Guns")

local camera = game.Workspace.CurrentCamera

local inventory = {
	"AK96",
	"Glock",
	"Toxic Spas",
	"Frag",
}

local loadedGun = {}

local gun = nil
local currentSlot = 2

function createGuns(char: Model)
	for i = 1, 3 do
		local module = require(GunClassFold:WaitForChild(inventory[i]))
		local newGun = module.New(char)
		loadedGun[inventory[i]] = newGun
		newGun.viewmodel.Parent = rf:WaitForChild("ViewmodelFoldPlayer")
		janitor:Add(loadedGun[inventory[i]], "Destroy")
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
	gun:PullOut()
end

local characterAdded = function(char)
	local hum = char:WaitForChild("Humanoid") :: Humanoid

	createGuns(char)
	loadSlot(inventory[currentSlot])

	janitor:Add(
		RunService.RenderStepped:Connect(function(dt)
			if gun then
				gun:RenderWork(dt)
			end
		end),
		"Disconnect"
	)

	local function changeSlotKeyPress(num: number, keycode)
		local action = keybindModule.GetAction("InGame", `ButtonPress({num})`)
		action.KeyboardBinding.KeyCode = keycode
		janitor:Add(
			action.Pressed:Connect(function()
				if currentSlot ~= num and gun ~= nil and gun.isReloading == false then
					loadSlot(inventory[num])
					currentSlot = num
					gun.aimCF = CFrame.new()
				end
			end),
			"Disconnect"
		)
	end

	changeSlotKeyPress(1, Enum.KeyCode.One)
	changeSlotKeyPress(2, Enum.KeyCode.Two)
	changeSlotKeyPress(3, Enum.KeyCode.Three)

	keybindModule.EnableContext("InGame")

	local mouse1 = keybindModule.GetAction("InGame", "Mouse1")
	mouse1.KeyboardBinding.KeyCode = Enum.KeyCode.MouseLeftButton
	janitor:Add(
		mouse1.Pressed:Connect(function()
			gun:Shoot()
		end),
		"Disconnect"
	)
	janitor:Add(
		mouse1.Released:Connect(function()
			gun.isShooting = false
		end),
		"Disconnect"
	)

	local mouse2 = keybindModule.GetAction("InGame", "Mouse2")
	mouse2.KeyboardBinding.KeyCode = Enum.KeyCode.MouseRightButton
	janitor:Add(
		mouse2.Pressed:Connect(function()
			gun.isAiming = true
		end),
		"Disconnect"
	)
	janitor:Add(
		mouse2.Released:Connect(function()
			gun.isAiming = false
		end),
		"Disconnect"
	)
	local reload = keybindModule.GetAction("InGame", "Reload")
	reload.KeyboardBinding.KeyCode = Enum.KeyCode.R
	janitor:Add(
		reload.Pressed:Connect(function()
			gun:Reload()
		end),
		"Disconnect"
	)

	local ability1 = keybindModule.GetAction("InGame", "Ability1")
	ability1.KeyboardBinding.KeyCode = Enum.KeyCode.E
	janitor:Add(
		ability1.Pressed:Connect(function()
			gun:Ability1()
		end),
		"Disconnect"
	)

	hum.Died:Once(function()
		currentSlot = 1
		janitor:Cleanup()
		for _, gun in pairs(loadedGun) do
			print("Destroy guns")
		end
		loadedGun = {}
		gun = nil
	end)
end

player.CharacterAdded:Connect(characterAdded)
local character = player.Character
if character then
	characterAdded(character)
end

return gunServiceClient
