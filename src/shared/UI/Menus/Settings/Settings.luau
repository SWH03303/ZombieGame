local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")

local player = game.Players.LocalPlayer

local components = ui:WaitForChild("Components")
local button = require(components:WaitForChild("Button"))

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
	return scope:New("Frame")({
		Name = "uh",
		Parent = props.Parent,
		Transparency = 0,
		BackgroundColor3 = Color3.new(0.52549, 0.560784, 0.666667),
		Position = UDim2.fromScale(0.25, 0.25),
		Size = UDim2.fromScale(0.25, 0.25),

		[Children] = {
			button({
				Position = UDim2.fromScale(0.25, 0.25),
				Size = UDim2.fromScale(1, 1),
				ButtonText = "skibidi",
				LayoutOrder = 10,
			}),
		},
	})
end
