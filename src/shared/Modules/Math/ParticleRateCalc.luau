local GraphicsLevel = UserSettings().GameSettings.SavedQualityLevel.Value

local function calcRate(originRate: number)
	return originRate * 10 / GraphicsLevel
end

return calcRate
