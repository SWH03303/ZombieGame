local enemyService = {}

local player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
local packets = require(modules:WaitForChild("Core"):WaitForChild("Packets"))
local Janitor = require(packages:WaitForChild("Janitor"))
local janitor = Janitor.new()

function enemyService.spawnRequest(name: string, position: Vector3)
	packets.spawnRequest:Fire(name, position)
end

return enemyService
