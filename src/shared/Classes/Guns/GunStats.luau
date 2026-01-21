local gunStats = {}

gunStats["Toxic Spas"] = {
	Name = "Toxic Spas",
	Ammo = 8,
	MaxAmmo = 8,
	Capacity = 64,
	Auto = false,
	MultiShot = 6,
	Damage = 9,
	CritDamage = 12,
	FireRate = 1,
	ReloadTime = 2.5,
	BulletTheme = "Green",
	Spread = 0.05,
	AimSpread = 0.05,
	Ability1CD = 0.1,
}

gunStats.Glock = {
	Name = "Glock",
	Ammo = 17,
	MaxAmmo = 17,
	Capacity = 102,
	Auto = false,
	Damage = 8,
	CritDamage = 12,
	FireRate = 0.15,
	ReloadTime = 1.5,
	Spread = 0.01,
	AimSpread = 0.005,
	Ability1CD = 0.1,
}

gunStats.AK96 = {
	Name = "AK96",
	Ammo = 30,
	MaxAmmo = 30,
	Capacity = 180,
	Auto = true,
	FireRate = 0.15,
	MaxSpread = 3,
	Damage = 10,
	CritDamage = 15,
	ReloadTime = 2,
	Spread = 0.015,
	AimSpread = 0.005,
	Ability1CD = 0.1,
}

return gunStats
