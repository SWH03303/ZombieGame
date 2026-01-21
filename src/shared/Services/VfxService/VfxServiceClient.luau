local rs = game:GetService("ReplicatedStorage")
local rf = game:GetService("ReplicatedFirst")
local packages = rs:WaitForChild("Packages")
local assets = rs:WaitForChild("Assets")
local shared = rs:WaitForChild("Shared")
local classes = shared:WaitForChild("Classes")
local vfxFold = classes:WaitForChild("Vfx")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local partCacheModule = require(rs:WaitForChild("Packages"):WaitForChild("PartCache"))

local vfx = {}

vfx.CreateBulletTrail = require(vfxFold:WaitForChild("BulletTrail"))
vfx.CreateGunMuzzle = require(vfxFold:WaitForChild("GunMuzzle"))
vfx.EnableSpeedlines = require(vfxFold:WaitForChild("Speedlines")).Start
vfx.DisableSpeedlines = require(vfxFold:WaitForChild("Speedlines")).Stop

return vfx
