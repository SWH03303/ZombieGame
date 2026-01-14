local Shared = {}

local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")
local mainFrame = require(ui:WaitForChild("Menus"):WaitForChild("Settings"):WaitForChild("Settings"))

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

local screen_gui = scope:New("ScreenGui")({
	Name = "Settings",
	Parent = player.PlayerGui,

	[Children] = {
		mainFrame.frame({}),
	},
})

local convertedContent = {}
local observers = {}
for name, config in pairs(mainFrame.content) do
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
end

janitor:Add(
	packet.alertLoadedData.OnClientEvent:Connect(function(data)
		local playerSettings = data.settings
		if playerSettings then
			for name, setting in pairs(playerSettings) do
				mainFrame.content[name].Value:set(setting.Value)
			end
		end
	end),
	"Disconnect"
)

print(convertedContent)

function Shared:Destroy()
	for _, observer in pairs(observers) do
		Fusion.doCleanup(observer)
	end
	janitor:Cleanup()
end

Shared.SettingsData = convertedContent

return Shared
