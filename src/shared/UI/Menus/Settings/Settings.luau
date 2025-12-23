local ScriptProfilerService = game:GetService("ScriptProfilerService")
local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local shared = rs:WaitForChild("Shared")

local module = shared:WaitForChild("Modules")
local tableUtils = require(module:WaitForChild("Platform"):WaitForChild("TableUtils"))

local ui = shared:WaitForChild("UI")
local uiSettingsFold = ui:WaitForChild("Menus"):WaitForChild("Settings")

local player = game.Players.LocalPlayer

local components = ui:WaitForChild("Components")

local Fusion = require(packages:WaitForChild("Fusion"))
local scoped = Fusion.scoped
local Children = Fusion.Children
local peek = Fusion.peek
local OnEvent = Fusion.OnEvent

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
		textBox = require(components:WaitForChild("TextBox")),
		sliderComponent = require(uiSettingsFold:WaitForChild("SliderComponent")),
		topSectionComponent = require(uiSettingsFold:WaitForChild("TopSectionComponent")),
		yesNoComponent = require(uiSettingsFold:WaitForChild("YesNoComponent")),

		masterVolume = { Value = scope:Value(100), Min = 0, Max = 200 },
		musicVolume = { Value = scope:Value(100), Min = 0, Max = 200 },
		effectVolume = { Value = scope:Value(100), Min = 0, Max = 200 },

		pov = { Value = scope:Value(90), Min = 30, Max = 120 },
		sensitivity = { Value = scope:Value(100), Min = 5, Max = 200 },
		adsSensitivityMultiplier = { Value = scope:Value(100), Min = 5, Max = 200 },
		cameraZoomEffect = { Value = scope:Value(100), Min = 0, Max = 100 },
		enableTexture = { Value = scope:Value(true) },
		damageNumber = { Value = scope:Value(true) },
		hideMuzzle = { Value = scope:Value(true) },
		content = {
			{ "topSectionComponent", "Sound" },
			{ "sliderComponent", "Master volume", "masterVolume" },
			{ "sliderComponent", "Music volume", "musicVolume" },
			{ "sliderComponent", "Effect volume", "effectVolume" },

			{ "topSectionComponent", "Gameplay" },
			{ "sliderComponent", "Field of view", "pov" },
			{ "sliderComponent", "Sensitivity", "sensitivity" },
			{ "sliderComponent", "ADS Multiplier", "adsSensitivityMultiplier" },
			{ "sliderComponent", "Camera Zoom Effect", "cameraZoomEffect" },
			{ "yesNoComponent", "Enable Texture", "enableTexture" },
			{ "yesNoComponent", "Show damage number", "damageNumber" },
			{ "yesNoComponent", "Hide muzzle effect", "hideMuzzle" },

			{ "topSectionComponent", "Control" },
		},
	})

	local function loadContent(padding: number)
		local content = {}

		for _, v in pairs(scope.content) do
			local contentType = v[1]
			table.insert(content, scope:emptyFrame({ Size = UDim2.fromScale(20, padding / 600) }))
			if contentType == "sliderComponent" then
				table.insert(
					content,
					scope:sliderComponent({
						Name = v[2],
						Value = scope[v[3]].Value,
						MaxValue = scope[v[3]].Max,
						MinValue = scope[v[3]].Min,
					})
				)
			elseif contentType == "yesNoComponent" then
				table.insert(
					content,
					scope:yesNoComponent({
						Name = v[2],
						Value = scope[v[3]].Value,
					})
				)
			elseif contentType == "topSectionComponent" then
				table.insert(content, scope:topSectionComponent({ Name = v[2] }))
			end
		end
		table.insert(content, scope:emptyFrame({ Size = UDim2.fromScale(20, padding / 600) }))

		return content
	end
	local settingsFrameChildren = {
		--scope:New("UIAspectRatioConstraint")({ AspectRatio = 1920 / 1080 }),
		--Heading
		scope:frame({
			Size = UDim2.fromScale(650 / 1920, 120 / 1080),
			BackgroundColor3 = Color3.new(0.858824, 0.87451, 0.407843),
			Position = UDim2.fromScale(700 / 1920, 170 / 1080),
			ZIndex = 2,
			BorderSizePixel = 8 / 120,
			BorderColor3 = Color3.new(0.737255, 0.756863, 0.196078),

			ExtraChildren = {
				scope:text({
					Text = "Settings",
					TextScaled = true,
					TextColor3 = Color3.new(0.564706, 0.576471, 0.164706),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 0.7),
				}),
				scope:New("UIAspectRatioConstraint")({ AspectRatio = 650 / 120 }),
			},
		}),
		--Close Button
		scope:button({
			Size = UDim2.fromScale(70 / 1920, 70 / 1080),
			BackgroundColor3 = Color3.new(0.87451, 0.407843, 0.407843),
			Position = UDim2.fromScale(1430 / 1920, 155 / 1080),
			ZIndex = 2,
			BorderSizePixel = 8 / 70,
			BorderColor3 = Color3.new(0.670588, 0.176471, 0.176471),
			ButtonText = "X",
			TextScaled = true,
			TextColor3 = Color3.new(0.670588, 0.176471, 0.176471),

			ExtraChildren = { scope:New("UIAspectRatioConstraint")({ AspectRatio = 1 }) },
		}),
		--Main Frame
		scope:scrollingFrame({
			Size = UDim2.fromScale(1000 / 1920, 600 / 1080),
			BackgroundColor3 = Color3.new(0.811765, 0.811765, 0.811765),
			Position = UDim2.fromScale(960 / 1920, 500 / 1080),
			ZIndex = 1,
			BorderSizePixel = 8 / 600,
			BorderColor3 = Color3.new(0.529412, 0.529412, 0.529412),
			BackgroundTransparency = 0.2,
			CornerRadius = UDim.new(0.02, 0),

			ExtraChildren = tableUtils.addIn({
				scope:New("UIListLayout")({
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				scope:emptyFrame({ Size = UDim2.fromOffset(20, 20) }),
				scope:New("UIAspectRatioConstraint")({ AspectRatio = 1000 / 600 }),
			}, loadContent(20)),
		}),
	}

	local settingsFrame = scope:New("Frame")({
		Parent = props.Parent,
		Transparency = 1,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),

		[Children] = settingsFrameChildren,
	})
	return settingsFrame
end
