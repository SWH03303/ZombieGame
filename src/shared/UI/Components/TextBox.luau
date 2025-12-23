local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")
local Text = require(script.Parent.Text)
local Fusion = require(packages:WaitForChild("Fusion"))
local scoped = Fusion.scoped
local peek = Fusion.peek
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed
type UsedAs<T> = Fusion.UsedAs<T>

local function Message(
	scope: Fusion.Scope,
	props: {
		Text: UsedAs<string>,
		Size: UsedAs<UDim2>?,
		TextScaled: UsedAs<BoolValue>?,
		TextColor3: UsedAs<string>?,
		TextSize: UsedAs<IntValue>?,
		AnchorPoint: UsedAs<Vector2>?,
		Position: UsedAs<UDim2>?,

		FocusLostEvent: UsedAs<any>?,
	}
)
	local textBox
	textBox = scope:New("TextBox")({
		Position = props.Position,
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
		Text = props.Text,
		Size = props.Size,
		TextScaled = props.TextScaled,
		TextSize = props.TextSize or 28,
		TextColor3 = props.TextColor3 or Color3.new(0.513725, 0.513725, 0.513725),
		FontFace = Font.fromName("ComicNeueAngular"),
		ClearTextOnFocus = true,

		[OnEvent("FocusLost")] = props.FocusLostEvent,
	})

	return textBox
end

return Message
