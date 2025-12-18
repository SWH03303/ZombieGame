local settings = {}

local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")

local components = require(packages:WaitForChild("FusionComponents"))
local button = require(components:WaitForChild("Button"))

local player = game.Players.LocalPlayer

local fusion = require(packages:WaitForChild("Fusion"))
local scoped = fusion.scoped
local Children = fusion.Children

local scope = scoped({
	New = fusion.New,
	Value = fusion.Value,
})

local screen_gui = scope:New("ScreenGui")({
	Name = "uh",
	Parent = player.PlayerGui,

	[Children] = {
		components.base.frame({}),
	},
})

return settings
