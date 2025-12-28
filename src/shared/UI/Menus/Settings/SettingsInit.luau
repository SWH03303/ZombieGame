local settings = {}

local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")
local mainFrame = require(ui:WaitForChild("Menus"):WaitForChild("Settings"):WaitForChild("Settings"))

local player = game.Players.LocalPlayer

local Fusion = require(packages:WaitForChild("Fusion"))
local scoped = Fusion.scoped
local Children = Fusion.Children
local peek = Fusion.peek

local scope = scoped(Fusion, {})

local screen_gui = scope:New("ScreenGui")({
	Name = "Settings",
	Parent = player.PlayerGui,

	[Children] = {
		mainFrame.frame({}),
	},
})

while task.wait(1) do
	print(peek(mainFrame.content.adsSensitivityMultiplier.Value))
end

return settings
