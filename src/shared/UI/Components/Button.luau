local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")

local player = game.Players.LocalPlayer

local fusion = require(packages:WaitForChild("Fusion"))
local scoped = fusion.scoped
local Children = fusion.Children

local scope = scoped({
	New = fusion.New,
	Value = fusion.Value,
})

return function(props: {
	Parent: Instance?,
})
	return scope:New("TextButton")({
		Name = "uh",
		Parent = props.Parent,
		Transparency = 0,
		Size = UDim2.fromScale(0.5, 0.5),
		Position = UDim2.fromScale(0.25, 0.25),
		Text = "Button",
		TextScaled = true,

		[Children] = {
			scope:New("UiCorner")({
				CornerRadius = UDim2.new(0, 8),
			}),
		},
	})
end
