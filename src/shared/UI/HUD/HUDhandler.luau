local Shared = {}

local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")
local hud = require(ui:WaitForChild("HUD"):WaitForChild("HUD"))

local player = game.Players.LocalPlayer

local Fusion = require(packages:WaitForChild("Fusion"))
local Janitor = require(packages:WaitForChild("Janitor"))
local packet = require(shared:WaitForChild("Modules"):WaitForChild("Core"):WaitForChild("Packets"))

local janitor = Janitor.new()
local scoped = Fusion.scoped
local Children = Fusion.Children
local peek = Fusion.peek
local Observer = Fusion.Observer

local scope = scoped(Fusion, {})
local hudFrame = hud.frame({})
local screen_gui = scope:New("ScreenGui")({
	Name = "HUD",
	Parent = player.PlayerGui,
	ScreenInsets = Enum.ScreenInsets.None,

	[Children] = {
		hudFrame,
	},
})
--[[
local convertedContent = {}
local observers = {}
for name, config in pairs(hud.content) do
	if type(config) == "table" and config.Value ~= nil then
		convertedContent[name] = peek(config.Value)

		local observer = scope:Observer(config.Value)

		table.insert(
			observers,
			observer:onChange(function()
				--print(`The new value of {name} is: `, peek(config.Value))
				packet.updateSettings:Fire(name, peek(config.Value))
				convertedContent[name] = peek(config.Value)
			end)
		)
	end
end]]

--Hit animation

Shared.HitMarker = function(critical: boolean)
	hud.content.createHitMarkerFunction(hudFrame, critical)
end

function Shared:Destroy()
	--[[
	for _, observer in pairs(observers) do
		Fusion.doCleanup(observer)
	end]]
	janitor:Cleanup()
end

Shared.Content = hud.content

return Shared
