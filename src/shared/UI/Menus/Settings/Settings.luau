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
	return scope:New("Frame")({
		Name = "uh",
		Parent = props.Parent,
		Transparency = 0,

		[Children] = {},
	})
end
