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
		Value: UsedAs<any>?,
		MaxValue: UsedAs<IntValue>?,
		MinValue: UsedAs<IntValue>?,
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

	local function addValue(n, val, max, min)
		if val + n > max then
			return max
		elseif val + n < min then
			return min
		else
			return val + n
		end
	end

	local function lostFocusNumbericTextBox(n, currentVal, max, min)
		if tonumber(n) == nil then
			return currentVal
		elseif tonumber(n) > max then
			return max
		elseif tonumber(n) < min then
			return min
		else
			return tonumber(n)
		end
	end

	local TextBox
	TextBox = scope:textBox({
		Text = props.Value,
		Size = UDim2.fromOffset(120, 75),
		TextSize = 50,

		FocusLostEvent = function()
			local currentVal = peek(props.Value)
			props.Value:set(lostFocusNumbericTextBox(TextBox.Text, currentVal, props.MaxValue, props.MinValue))
			TextBox.Text = peek(props.Value)
		end,
	})

	return scope:frame({
		Size = UDim2.fromOffset(900, 100),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(0.470588, 0.470588, 0.470588),
		ExtraChildren = {
			scope:New("UIListLayout")({
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 20),
			}),
			scope:text({
				Text = props.Name,
				Size = UDim2.fromOffset(450, 75),
				TextSize = 50,
				TextColor3 = Color3.new(0.890196, 0.890196, 0.890196),
				TextXAlignment = Enum.TextXAlignment.Left,
			}),
			scope:button({
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(75, 75),
				ButtonText = "-",
				LayoutOrder = 1,
				TextSize = 60,
				OnEventFunction = function()
					props.Value:set(addValue(-5, peek(props.Value), props.MaxValue, props.MinValue))
				end,
			}),
			scope:frame({
				Size = UDim2.fromOffset(120, 75),
				LayoutOrder = 2,
				BorderSizePixel = 0,
				ExtraChildren = { TextBox },
			}),
			scope:button({
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(75, 75),
				ButtonText = "+",
				LayoutOrder = 3,
				TextSize = 60,
				OnEventFunction = function()
					props.Value:set(addValue(5, peek(props.Value), props.MaxValue, props.MinValue))
				end,
			}),
		},
	})
end
