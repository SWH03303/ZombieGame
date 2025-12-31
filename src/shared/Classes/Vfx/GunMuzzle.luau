local rs = game:GetService("ReplicatedStorage")
local partCacheModule = require(rs:WaitForChild("Packages"):WaitForChild("PartCache"))
local muzzle = rs:WaitForChild("Assets"):WaitForChild("Vfx"):WaitForChild("GunMuzzle")

local theme = {
	Yellow = {
		Muzzle_Flash1 = { Color = ColorSequence.new(Color3.fromRGB(200, 90, 29)) },
		Muzzle_Flash2 = { Color = ColorSequence.new(Color3.fromRGB(255, 170, 59)) },
		Muzzle_Flash3 = { Color = ColorSequence.new(Color3.fromRGB(255, 240, 120)) },
		Muzzle_Flash4 = { Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)) },
	},
	Green = {
		Muzzle_Flash1 = { Color = ColorSequence.new(Color3.fromRGB(40, 90, 35)) },
		Muzzle_Flash2 = { Color = ColorSequence.new(Color3.fromRGB(90, 170, 80)) },
		Muzzle_Flash3 = { Color = ColorSequence.new(Color3.fromRGB(160, 240, 120)) },
		Muzzle_Flash4 = { Color = ColorSequence.new(Color3.fromRGB(230, 255, 210)) },
	},
}

local ApplyThemeChange = function(themeFold, part)
	part.Muzzle_Flash1.Color = themeFold.Muzzle_Flash1.Color
	part.Muzzle_Flash2.Color = themeFold.Muzzle_Flash2.Color
	part.Muzzle_Flash3.Color = themeFold.Muzzle_Flash3.Color
	part.Muzzle_Flash4.Color = themeFold.Muzzle_Flash4.Color
end

function CreateGunMuzzle(att, themeName)
	if not att:FindFirstChild("Muzzle_Flash1") then
		for _, child in pairs(muzzle:GetChildren()) do
			local clone = child:Clone()
			clone.Parent = att
		end
		ApplyThemeChange(theme[themeName], att)
	end
	att.Muzzle_Flash1:Emit(1)
	att.Muzzle_Flash2:Emit(1)
	att.Muzzle_Flash3:Emit(1)
	att.Muzzle_Flash4:Emit(1)

	return
end

return CreateGunMuzzle
