local AttackServiceServer = {}

local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local classes = shared:WaitForChild("Classes")
local attackClasses = classes:WaitForChild("Attacks")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local packages = rs:WaitForChild("Packages")

local Explosion = require(attackClasses:WaitForChild("Explosion"))
AttackServiceServer.Explosion = Explosion
local Projectile = require(attackClasses:WaitForChild("Projectile"))
AttackServiceServer.Projectile = Projectile

return AttackServiceServer
