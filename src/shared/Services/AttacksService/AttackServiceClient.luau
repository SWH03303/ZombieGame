local AttackServiceClient = {}

local rs = game:GetService("ReplicatedStorage")
local shared = rs:WaitForChild("Shared")
local classes = shared:WaitForChild("Classes")
local attackClasses = classes:WaitForChild("Attacks")
local modules = shared:WaitForChild("Modules")
local services = shared:WaitForChild("Services")
local packages = rs:WaitForChild("Packages")

local Explosion = require(attackClasses:WaitForChild("Explosion"))
AttackServiceClient.Explosion = Explosion
local Projectile = require(attackClasses:WaitForChild("Projectile"))
AttackServiceClient.Projectile = Projectile

return AttackServiceClient
