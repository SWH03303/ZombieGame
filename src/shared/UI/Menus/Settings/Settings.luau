local OmniRecommendationsService = game:GetService("OmniRecommendationsService")
local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")

local player = game.Players.LocalPlayer

local components = ui:WaitForChild("Components")

local Fusion = require(packages:WaitForChild("Fusion"))
local scoped = Fusion.scoped
local Children = Fusion.Children
local peek = Fusion.peek
local OnEvent = Fusion.OnEvent

type UsedAs<T> = Fusion.UsedAs<T>

local scope = scoped(Fusion, {})

return function(
	--scope: Fusion.Scope,
	props: {
		Parent: UsedAs<Instance>?,
	}
)
	local scope = scope:innerScope({
		button = require(components:WaitForChild("Button")),
		frame = require(components:WaitForChild("Frame")),
		scrollingFrame = require(components:WaitForChild("ScrollingFrame")),
		text = require(components:WaitForChild("Text")),
		emptyFrame = require(components:WaitForChild("EmptyFrame")),
		textBox = require(components:WaitForChild("TextBox")),
		sliderComponent = require(ui:WaitForChild("Menus"):WaitForChild("Settings"):WaitForChild("SliderComponent")),
		masterVolume = { Value = scope:Value(100), Min = 0, Max = 200 },
		musicVolume = { Value = scope:Value(100), Min = 0, Max = 200 },
		effectVolume = { Value = scope:Value(100), Min = 0, Max = 200 },
	})

	local function addPadding(num, childFold)
		local paddedChildFold = {}
		for _, v in pairs(childFold) do
			if v:IsA("Frame") then
				table.insert(paddedChildFold, scope:emptyFrame({ Size = UDim2.fromOffset(20, num) }))
			end
			table.insert(paddedChildFold, v)
		end
		table.insert(paddedChildFold, scope:emptyFrame({ Size = UDim2.fromOffset(20, num) }))
		return paddedChildFold
	end

	local settingsFrameChildren = {
		scope:scrollingFrame({
			Size = UDim2.fromOffset(1000, 600),
			BackgroundColor3 = Color3.new(0.811765, 0.811765, 0.811765),
			Position = UDim2.fromOffset(960 - 500, 500 - 300),
			ZIndex = 1,
			BorderSizePixel = 8,
			BorderColor3 = Color3.new(0.529412, 0.529412, 0.529412),

			ExtraChildren = addPadding(25, {
				scope:New("UIListLayout")({
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),

				scope:sliderComponent({
					Name = "Master Volume",
					Value = scope.masterVolume.Value,
					MaxValue = scope.masterVolume.Max,
					MinValue = scope.masterVolume.Min,
				}),
				scope:sliderComponent({
					Name = "Music Volume",
					Value = scope.musicVolume.Value,
					MaxValue = scope.musicVolume.Max,
					MinValue = scope.musicVolume.Min,
				}),
				scope:sliderComponent({
					Name = "Effect Volume",
					Value = scope.effectVolume.Value,
					MaxValue = scope.effectVolume.Max,
					MinValue = scope.effectVolume.Min,
				}),
			}),
		}),
	}

	local settingsFrame = scope:New("Frame")({
		Parent = props.Parent,
		Transparency = 1,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),

		[Children] = settingsFrameChildren,
	})
	return settingsFrame
end
