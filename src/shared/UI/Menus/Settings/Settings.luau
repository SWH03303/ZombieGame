local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")
local ui = shared:WaitForChild("UI")

local player = game.Players.LocalPlayer

local components = ui:WaitForChild("Components")

local Fusion = require(packages:WaitForChild("Fusion"))
local scoped = Fusion.scoped
local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

local scope = scoped(Fusion, {})

return function(
	--scope: Fusion.Scope,
	props: {
		Parent: UsedAs<Instance>?,
	}
)
	local scope = scope:innerScope({
		button = require(components:WaitForChild("Button")),
		frame = require(components:WaitForChild("Frame")),
	})

	return scope:New("Frame")({
		Parent = props.Parent,
		Transparency = 1,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),

		[Children] = {

			scope:frame({
				Size = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = Color3.new(0.8, 0.811765, 0.847059),
				Position = UDim2.fromScale(0.25, 0.25),
				ZIndex = 1,

				[Children] = {
					--scope:New("UIListLayout")({}),
					scope:button({
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1, 1),
						ButtonText = "skibidi",
						ZIndex = 2,
						--TextColor3 = Color3.new(0.819608, 0.05098, 0.05098),
						--BorderSizePixel = 10,
					}),
				},
			}),
		},
	})
end
