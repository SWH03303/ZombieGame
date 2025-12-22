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
		masterVolume = scope:Value(100),
		masterVolumeMax = 200,
		masterVolumeMin = 0,
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

	local masterVolumeTextBox
	masterVolumeTextBox = scope:textBox({
		Text = scope.masterVolume,
		Size = UDim2.fromOffset(120, 75),
		TextSize = 50,

		FocusLostEvent = function()
			local currentVal = peek(scope.masterVolume)
			scope.masterVolume:set(
				lostFocusNumbericTextBox(
					masterVolumeTextBox.Text,
					currentVal,
					scope.masterVolumeMax,
					scope.masterVolumeMin
				)
			)
			masterVolumeTextBox.Text = peek(scope.masterVolume)
		end,
	})

	local settingsFrameChildren = {
		scope:scrollingFrame({
			Size = UDim2.fromOffset(800, 500),
			BackgroundColor3 = Color3.new(0.8, 0.811765, 0.847059),
			Position = UDim2.fromOffset(960 - 400, 500 - 250),
			ZIndex = 1,
			ExtraChildren = addPadding(25, {
				scope:New("UIListLayout")({
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),

				--MASTER VOLUME
				scope:frame({
					Size = UDim2.fromOffset(700, 100),
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
							Text = "Master Volume",
							Size = UDim2.fromOffset(120, 75),
							TextSize = 50,
							TextColor3 = Color3.new(0.890196, 0.890196, 0.890196),
						}),
						scope:button({
							BorderSizePixel = 0,
							Size = UDim2.fromOffset(75, 75),
							ButtonText = "-",
							LayoutOrder = 1,
							TextSize = 50,
							OnEventFunction = function()
								scope.masterVolume:set(
									addValue(-1, peek(scope.masterVolume), scope.masterVolumeMax, scope.masterVolumeMin)
								)
							end,
						}),
						scope:frame({
							Size = UDim2.fromOffset(120, 75),
							LayoutOrder = 2,
							BorderSizePixel = 0,
							ExtraChildren = { masterVolumeTextBox },
						}),
						scope:button({
							BorderSizePixel = 0,
							Size = UDim2.fromOffset(75, 75),
							ButtonText = "+",
							LayoutOrder = 3,
							TextSize = 50,
							OnEventFunction = function()
								scope.masterVolume:set(
									addValue(1, peek(scope.masterVolume), scope.masterVolumeMax, scope.masterVolumeMin)
								)
							end,
						}),
					},
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
