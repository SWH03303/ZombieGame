local settings = {}

local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")

local components = ui:WaitForChild("Components")
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
		scope:New("Frame")({
			Name = "Hello",

			Size = UDim2.fromScale(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),

			[Children] = {
				button({
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromScale(0.5, 0.5),
					ButtonText = "Skibidi",
				}),
			},
		}),
	},
})

return settings
