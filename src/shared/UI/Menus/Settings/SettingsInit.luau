local settings = {}

local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")
local mainFrame = require(ui:WaitForChild("Menus"):WaitForChild("Settings"):WaitForChild("Settings"))

local fusionComponents = require(packages:WaitForChild("FusionComponents"))

local player = game.Players.LocalPlayer

local fusion = require(packages:WaitForChild("Fusion"))
local scoped = fusion.scoped
local Children = fusion.Children

local scope = scoped({
	New = fusion.New,
	Value = fusion.Value,
})

local screen_gui = scope:New("ScreenGui")({
	Name = "Settings",
	Parent = player.PlayerGui,

	[Children] = {
		mainFrame({}),
	},
})

return settings
