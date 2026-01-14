local ui = {}

local rs = game:GetService("ReplicatedStorage")
local assets = rs:WaitForChild("Assets")
local shared = rs:WaitForChild("Shared")
local uiFold = shared:WaitForChild("UI")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")

local packages = rs:WaitForChild("Packages")
local tableUtil = require(packages:WaitForChild("TableUtil"))

local Players = game:GetService("Players")

--local moduleLoader = require(modules:WaitForChild("Platform"):WaitForChild("ModuleLoader"))
--moduleLoader:FetchAllServices(uiFold, uiFold:WaitForChild("UI"))

local settings = require(uiFold:WaitForChild("Menus"):WaitForChild("Settings"):WaitForChild("SettingsHandler"))
local hud = require(uiFold:WaitForChild("HUD"):WaitForChild("HUDhandler"))

return ui
