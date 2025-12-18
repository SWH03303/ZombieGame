local Studio = settings().Studio
local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local themeFramework = require(packages:WaitForChild("themeFramework"))
local fusion = require(packages:WaitForChild("Fusion"))
local Clean = fusion.cleanup

export type color = themeFramework.color
export type colorTable = themeFramework.colorTable
export type optionalColorTable = themeFramework.optionalColorTable
export type useColorFunction = themeFramework.useColorFunction

local theme = themeFramework.new(script.components, function(self, themeName)
	-- This function is called whenever the theme is successfully rebuilt.
	-- This is useful for registering a fallback color for the theme
	-- or global values that can be read from the theme.
	self:setFallback(themeName == "Dark" and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(255, 255, 255))
end)

-- Register connections to handle theme changes
local connections = {
	Studio.ThemeChanged:Connect(function()
		-- theme:build calls all theme functions and packs them into a table
		theme:load(theme:build(Studio.Theme.Name))
	end),
	script.Destroying:Connect(function()
		theme.destroy()
	end),
}

theme:load(theme:build(Studio.Theme.Name))

return setmetatable({
	-- Add your own methods here, for ex. exposing globals such as isDark
	-- can be useful to respond to theme changes efficiently
	destroy = function()
		-- Clean up connections, so that testing doesn't result in massive memory
		-- leaks, especially when changing theme
		Clean(connections)
		theme = nil
	end,
}, {
	__index = theme,
}) :: themeFramework.themeFramework & {
	destroy: () -> (),
}
