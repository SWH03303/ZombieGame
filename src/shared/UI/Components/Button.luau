local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")

local player = game.Players.LocalPlayer

local Fusion = require(packages:WaitForChild("Fusion"))
local scoped = Fusion.scoped
local Children = Fusion.Children

local scope = scoped({
	New = Fusion.New,
	Value = Fusion.Value,
})

type UsedAs<T> = Fusion.UsedAs<T>

return function(props: {
	Position: UsedAs<UDim2>?,
	AnchorPoint: UsedAs<Vector2>?,
	Size: UsedAs<UDim2>?,
	LayoutOrder: UsedAs<number>?,
	ButtonText: UsedAs<string>,
})
	return scope:New("TextButton")({
		BackgroundColor3 = Color3.new(0, 0.25, 1),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		Size = props.Size,
		LayoutOrder = props.LayoutOrder,

		Text = props.ButtonText,
		TextSize = 28,
		TextColor3 = Color3.new(1, 1, 1),

		[Children] = {
			scope:New("UICorner")({
				CornerRadius = UDim.new(0, 8),
			}),
		},
	})
end
