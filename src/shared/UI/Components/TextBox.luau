local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")
local Fusion = require(packages:WaitForChild("Fusion"))
type UsedAs<T> = Fusion.UsedAs<T>

local function Message(
	scope: Fusion.Scope,
	props: {
		Text: UsedAs<string>,
		Size: UsedAs<UDim2>?,
		TextScaled: UsedAs<BoolValue>?,
		TextColor3: UsedAs<string>?,
		TextSize: UsedAs<IntValue>?,
	}
)
	return scope:New("TextBox")({
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
		Text = props.Text,
		Size = props.Size,
		TextScaled = props.TextScaled,
		TextSize = props.TextSize or 28,
		TextColor3 = props.TextColor3 or Color3.new(0.513725, 0.513725, 0.513725),
		FontFace = Font.fromName("ComicNeueAngular"),
	})
end

return Message
