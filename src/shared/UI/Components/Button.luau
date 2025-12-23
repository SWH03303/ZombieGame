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

type UsedAs<T> = Fusion.UsedAs<T>

return function(
	scope: Fusion.Scope,
	props: {
		Visible: UsedAs<boolean>?,
		Position: UsedAs<UDim2>?,
		AnchorPoint: UsedAs<Vector2>?,
		Size: UsedAs<UDim2>?,
		LayoutOrder: UsedAs<number>?,
		ZIndex: UsedAs<IntValue>?,
		CornerRadius: UsedAs<UDim>?,

		TextColor3: UsedAs<Color3>?,
		ButtonText: UsedAs<string>?,
		FontName: UsedAs<Enum.Font>?,
		TextScaled: UsedAs<BoolValue>?,
		TextSize: UsedAs<IntValue>?,

		BackgroundColor3: UsedAs<Color3>?,
		BorderSizePixel: UsedAs<IntValue>?,
		BorderColor3: UsedAs<Color3>?,

		ExtraChildren: UsedAs<SharedTable>?,
		OnEventFunction: UsedAs<Instance>?,
	}
)
	return scope:New("TextButton")({
		Visible = props.Visible,
		BackgroundColor3 = props.BackgroundColor3 or Color3.new(0.898039, 0.898039, 0.898039),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		Size = props.Size,
		LayoutOrder = props.LayoutOrder,
		AutoButtonColor = true,
		ZIndex = props.ZIndex or 0,

		Text = props.ButtonText,
		TextSize = props.TextSize or 28,
		TextColor3 = props.TextColor3 or Color3.new(0.513725, 0.513725, 0.513725),
		FontFace = Font.fromName("ComicNeueAngular"),
		TextScaled = props.TextScaled,

		[OnEvent("Activated")] = props.OnEventFunction,

		[Children] = TableUtil.addIn({
			scope:New("UICorner")({
				CornerRadius = props.CornerRadius or UDim.new(0.1, 0),
			}),
			scope:New("UIStroke")({
				BorderStrokePosition = Enum.BorderStrokePosition.Center,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
				Thickness = props.BorderSizePixel or 0.2,
				Color = props.BorderColor3 or Color3.new(0.517647, 0.517647, 0.517647),
			}),
		}, props.ExtraChildren),
	})
end
