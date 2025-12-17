local ui = {}

local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")

local player = game.Players.LocalPlayer

local fusion = require(packages:WaitForChild("Fusion"))
local scoped = fusion.scoped

local scope = scoped({
	New = fusion.New,
})

local screen_gui = scope:New("ScreenGui")({
	Name = "uh",
	Parent = player.PlayerGui,
})

return ui
