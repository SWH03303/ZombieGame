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
	}
)
	return scope:New("TextLabel")({
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
		Text = props.Text,
	})
end

return Message
