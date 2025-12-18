local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")

local fusion = require(packages:WaitForChild("Fusion"))
local scoped = fusion.scoped
local Children = fusion.Children
type UsedAs<T> = fusion.UsedAs<T>

return function(
	scope: fusion.Scope,
	props: {
		Position: UsedAs<UDim2>?,
		AnchorPoint: UsedAs<Vector2>?,
		Size: UsedAs<UDim2>?,
		LayoutOrder: UsedAs<number>?,
		ButtonText: UsedAs<string>,
	}
)
	scope:New("TextButton")({
		BackgroundColor3 = Color3.new(0, 0.25, 1),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		Size = props.Size,
		LayoutOrder = props.LayoutOrder,

		Text = props.ButtonText,
		TextSize = 28,
		TextColor3 = Color3.new(1, 1, 1),

		[Children] = scope:New("UICorner")({ CornerRadius = UDim2.new(0, 8) }),
	})
end
