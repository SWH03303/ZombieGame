local Shared = {}

Shared.DEFAULT_PLAYER_DATA = {
	settings = {
		masterVolume = { Value = 100, Min = 0, Max = 200 },
		musicVolume = { Value = 100, Min = 0, Max = 200 },
		effectVolume = { Value = 100, Min = 0, Max = 200 },

		fieldOfView = { Value = 90, Min = 30, Max = 120 },
		sensitivity = { Value = 100, Min = 5, Max = 200 },
		adsSensitivityMultiplier = { Value = 100, Min = 5, Max = 200 },
		cameraZoomEffect = { Value = 100, Min = 0, Max = 100 },
		enableTexture = { Value = true },
		damageNumber = { Value = true },
		hideMuzzle = { Value = true },
	},
}

export type PlayerData = typeof(Shared.DEFAULT_PLAYER_DATA)

return Shared
