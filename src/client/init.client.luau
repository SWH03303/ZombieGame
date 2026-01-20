local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local classes = shared:WaitForChild("Classes")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")

local gunService = services:WaitForChild("GunService")
require(gunService:WaitForChild("GunServiceClient"))

local uiFold = shared:WaitForChild("UI")
require(uiFold:WaitForChild("UI"))

local playerDataService = services:WaitForChild("PlayerDataService")
require(playerDataService:WaitForChild("PlayerDataServiceClient"))

local movementService = services:WaitForChild("MovementService")
require(movementService:WaitForChild("MovementServiceClient"))

local attackService = services:WaitForChild("AttacksService")
require(attackService:WaitForChild("AttackServiceClient"))
