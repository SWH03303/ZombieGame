local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local module = shared:WaitForChild("Modules")
local TableUtil = require(module:WaitForChild("Platform"):WaitForChild("TableUtils"))
local ui = shared:WaitForChild("UI")

local components = ui:WaitForChild("Components")
local player = game.Players.LocalPlayer

local Fusion = require(packages:WaitForChild("Fusion"))
local scoped = Fusion.scoped
local peek = Fusion.peek
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed

type UsedAs<T> = Fusion.UsedAs<T>

local scope = scoped(Fusion, {})

return function(
	scope: Fusion.Scope,
	props: {
		Name: UsedAs<string>?,
	}
)
	local scope = scope:innerScope({
		button = require(components:WaitForChild("Button")),
		frame = require(components:WaitForChild("Frame")),
		scrollingFrame = require(components:WaitForChild("ScrollingFrame")),
		text = require(components:WaitForChild("Text")),
		emptyFrame = require(components:WaitForChild("EmptyFrame")),
		textBox = require(components:WaitForChild("TextBox")),
	})

	return scope:frame({
		Size = UDim2.fromOffset(900, 100),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(0.309804, 0.309804, 0.309804),
		ExtraChildren = {
			scope:text({
				Text = props.Name,
				Size = UDim2.fromOffset(900, 100),
				TextSize = 70,
				TextColor3 = Color3.new(0.890196, 0.890196, 0.890196),
			}),
		},
	})
end
