local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local module = shared:WaitForChild("Modules")
local TableUtil = require(module:WaitForChild("Platform"):WaitForChild("TableUtils"))
local ui = shared:WaitForChild("UI")

local player = game.Players.LocalPlayer

local Fusion = require(packages:WaitForChild("Fusion"))
local scoped = Fusion.scoped
local peek = Fusion.peek
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed

--local scope = scoped(Fusion, {})

type UsedAs<T> = Fusion.UsedAs<T>

return function(
	scope: Fusion.Scope,
	props: {
		Position: UsedAs<UDim2>?,
		AnchorPoint: UsedAs<Vector2>?,
		Size: UsedAs<UDim2>?,
		LayoutOrder: UsedAs<number>?,
		ZIndex: UsedAs<IntValue>?,

		BackgroundColor3: UsedAs<Color3>?,
		BorderSizePixel: UsedAs<IntValue>?,
		BorderColor3: UsedAs<Color3>?,
		ExtraChildren: UsedAs<SharedTable>?,
	}
)
	print("ey")
	local scrollingFrame = scope:New("ScrollingFrame")({
		CanvasSize = UDim2.fromScale(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,

		BackgroundColor3 = props.BackgroundColor3 or Color3.new(0.898039, 0.898039, 0.898039),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		Size = props.Size,
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex or 0,

		[Children] = TableUtil.addIn({
			scope:New("UICorner")({
				CornerRadius = UDim.new(0, 8),
			}),
			scope:New("UIStroke")({
				BorderStrokePosition = Enum.BorderStrokePosition.Center,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = props.BorderSizePixel or 5,
				Color = props.BorderColor3 or Color3.new(0.517647, 0.517647, 0.517647),
			}),
		}, props.ExtraChildren),
	})

	return scrollingFrame
end
