local Shared = {}

Shared.DEFAULT_PLAYER_DATA = {
	settings = {
		masterVolume = 100,
		musicVolume = 100,
		effectVolume = 100,

		pov = 90,
		sensitivity = 100,
		adsSensitivityMultiplier = 100,
		cameraZoomEffect = 100,
		enableTexture = true,
		damageNumber = true,
		hideMuzzle = true,
	},
}

export type PlayerData = typeof(Shared.DEFAULT_PLAYER_DATA)

return Shared
