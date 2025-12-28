local rs = game:GetService("ReplicatedStorage")
local rf = game:GetService("ReplicatedFirst")
local packages = rs:WaitForChild("Packages")
local assets = rs:WaitForChild("Assets")
local shared = rs:WaitForChild("Shared")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local player = game:GetService("Players").LocalPlayer
local playerDataService = services:WaitForChild("PlayerDataService")

local packet = require(modules:WaitForChild("Core"):WaitForChild("Packets"))
local Janitor = require(packages:WaitForChild("Janitor"))
local promise = require(packages:WaitForChild("Promise"))
local defaultData = require(playerDataService:WaitForChild("PlayerDataDefault")).DEFAULT_PLAYER_DATA

local Local = {}
local Shared = {}

Shared.playerData = defaultData

packet.alertLoadedData.OnClientEvent:Connect(function(data)
	Shared.playerData = data
end)

return Shared
