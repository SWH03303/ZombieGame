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
		scrollingFrame = require(components:WaitForChild("ScrollingFrame")),
		text = require(components:WaitForChild("Text")),
		emptyFrame = require(components:WaitForChild("EmptyFrame")),
	})

	--[[]]

	local settingsFrame = scope:New("Frame")({
		Parent = props.Parent,
		Transparency = 1,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),

		[Children] = {
			scope:scrollingFrame({
				Size = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = Color3.new(0.8, 0.811765, 0.847059),
				Position = UDim2.fromScale(0.25, 0.25),
				ZIndex = 1,
				ExtraChildren = {
					scope:New("UIListLayout")({
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					}),

					scope:emptyFrame({ Size = UDim2.fromScale(1, 0.05) }),

					scope:emptyFrame({
						Size = UDim2.fromScale(1, 0.3),
						ExtraChildren = {
							scope:New("UIListLayout")({
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								FillDirection = Enum.FillDirection.Horizontal,
								Padding = UDim.new(0.1),
							}),
							scope:button({
								--Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromScale(0.3, 1),
								ButtonText = "skibidi",
								ZIndex = 2,
							}),
							scope:button({
								--Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromScale(0.3, 1),
								ButtonText = "skibidi",
								ZIndex = 2,
							}),
						},
					}),

					scope:emptyFrame({ Size = UDim2.fromScale(1, 0.05) }),

					scope:emptyFrame({
						Size = UDim2.fromScale(1, 0.3),
						ExtraChildren = {
							scope:New("UIListLayout")({
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								FillDirection = Enum.FillDirection.Horizontal,
								Padding = UDim.new(0.1),
							}),
							scope:button({
								--Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromScale(0.3, 1),
								ButtonText = "skibidi",
								ZIndex = 2,
							}),
							scope:button({
								--Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromScale(0.3, 1),
								ButtonText = "skibidi",
								ZIndex = 2,
							}),
						},
					}),

					scope:emptyFrame({ Size = UDim2.fromScale(1, 0.05) }),

					scope:emptyFrame({
						Size = UDim2.fromScale(1, 0.3),
						ExtraChildren = {
							scope:New("UIListLayout")({
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								FillDirection = Enum.FillDirection.Horizontal,
								Padding = UDim.new(0.1),
							}),
							scope:button({
								--Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromScale(0.3, 1),
								ButtonText = "skibidi",
								ZIndex = 2,
							}),
							scope:button({
								--Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromScale(0.3, 1),
								ButtonText = "skibidi",
								ZIndex = 2,
							}),
						},
					}),

					scope:emptyFrame({ Size = UDim2.fromScale(1, 0.05) }),
				},
			}),
		},
	})
	--[[
	print(settingsFrame:GetChildren())

	local observer = scope:Observer(settingsFrame.ScrollingFrame.UIListLayout.AbsoluteContentSize)
	observer:onBind(function()
		local absoluteSize = settingsFrame.ScrollingFrame.UIListLayout.AbsoluteContentSize
		settingsFrame.ScrollingFrame.CanvasSize = UDim2.fromOffset(0, absoluteSize.Y)
	end)]]

	return settingsFrame
end
