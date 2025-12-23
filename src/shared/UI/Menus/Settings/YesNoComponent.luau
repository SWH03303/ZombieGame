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
	}
)
	local displayText = scope:Computed(function(use, scope)
		use(props.Value)
		if peek(props.Value) then
			return "✓"
		else
			return " "
		end
	end)

	return scope:frame({
		Size = UDim2.fromScale(900 / 1000, 100 / 600),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(0.470588, 0.470588, 0.470588),
		ExtraChildren = {
			scope:New("UIListLayout")({
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(20 / 900, 0),
			}),
			scope:text({
				Text = props.Name,
				Size = UDim2.fromScale(685 / 900, 60 / 100),
				TextScaled = true,
				TextColor3 = Color3.new(0.890196, 0.890196, 0.890196),
				TextXAlignment = Enum.TextXAlignment.Left,
			}),
			scope:button({
				BorderSizePixel = 0,
				Size = UDim2.fromScale(75 / 900, 75 / 100),
				ButtonText = displayText,
				LayoutOrder = 3,
				TextScaled = true,
				OnEventFunction = function()
					props.Value:set(not peek(props.Value))
				end,
			}),
		},
	})
end
