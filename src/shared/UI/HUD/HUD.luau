local ScriptProfilerService = game:GetService("ScriptProfilerService")
local runService = game:GetService("RunService")
local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")

local module = shared:WaitForChild("Modules")
local tableUtils = require(module:WaitForChild("Platform"):WaitForChild("TableUtils"))
local packet

local ui = shared:WaitForChild("UI")
local uiSettingsFold = ui:WaitForChild("Menus"):WaitForChild("Settings")

local player = game.Players.LocalPlayer

local components = ui:WaitForChild("Components")

local Fusion = require(packages:WaitForChild("Fusion"))
local scoped = Fusion.scoped
local Children = Fusion.Children
local peek = Fusion.peek
local OnEvent = Fusion.OnEvent
local Observer = Fusion.Observer

type UsedAs<T> = Fusion.UsedAs<T>

local scope = scoped(Fusion, {})

--Load player settings

local inner = {
	hitMarker = scope:Value(false),
	hitMarkerTransparency = scope:Value(1),
	gunName = scope:Value("Glock"),
	ammo = scope:Value(10),
	maxAmmo = scope:Value(100),
}

return {
	content = inner,
	frame = function(
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
			textBox = require(components:WaitForChild("TextBox")),
			sliderComponent = require(uiSettingsFold:WaitForChild("SliderComponent")),
			topSectionComponent = require(uiSettingsFold:WaitForChild("TopSectionComponent")),
			yesNoComponent = require(uiSettingsFold:WaitForChild("YesNoComponent")),
		})

		local screenFrameChildren = {
			scope:New("UIAspectRatioConstraint")({ AspectRatio = 1920 / 1080 }),

			--HitMarker
			scope:New("ImageLabel")({
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.025, 0.025),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = "http://www.roblox.com/asset/?id=1648882980",
				Transparency = 1,
				ImageTransparency = inner.hitMarkerTransparency,

				[Children] = {
					scope:New("UIAspectRatioConstraint")({ AspectRatio = 1 }),
				},
			}),

			--Ammo/Gun name
			scope:frame({
				Position = UDim2.fromScale(0.1, 0.8),
				Size = UDim2.fromScale(0.15, 0.15),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BorderSizePixel = 0.02,
				BorderColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				ExtraChildren = {
					scope:New("UIAspectRatioConstraint")({ AspectRatio = 2.5 }),
					scope:New("UIListLayout")({
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
					}),
					scope:text({
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1, 0.5),
						TextScaled = true,
						TextColor3 = Color3.new(1, 1, 1),
						Text = inner.gunName,
					}),
					scope:text({
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1, 0.5),
						TextScaled = true,
						TextColor3 = Color3.new(1, 1, 1),
						Text = inner.ammo,
					}),
				},
			}),
		}

		local screenFrame = scope:New("Frame")({
			Parent = props.Parent,
			Transparency = 1,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),

			[Children] = screenFrameChildren,
		})
		return screenFrame
	end,
}
