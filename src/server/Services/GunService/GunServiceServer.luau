local rs = game:GetService("ReplicatedStorage")
local sss = game:GetService("ServerScriptService")
local shared = rs.Shared
local modules = shared.Modules
local class = shared.Classes
local assets = rs.Assets
local guns = class.Guns
local serverClasses = sss.Server.Classes
local gunsServer = serverClasses.Guns
local packet = require(modules.Core.Packets)

local Shared = {}

require(gunsServer.AK96)
local gunStats = require(guns.GunStats)
print(gunStats)

packet.shoot.OnServerInvoke = function(player, shooter, enemy, hitPart, gunName) -- need to validate damage
	--print(gunStats)
	if enemy:GetAttribute("Team") == "Ally" then
		return 0
	end

	local damage
	if hitPart == "Head" then
		damage = gunStats[gunName].CritDamage
		--print(`{player.Name} shot {enemy.Name} in the {hitPart} dealing {damage} HP using {gunName} (SERVER)`)
	else
		damage = gunStats[gunName].Damage
		--print(`{player.Name} shot {enemy.Name} in the {hitPart} dealing {damage} HP using {gunName} (SERVER)`)
	end
	enemy.Humanoid.Health -= damage
	return damage
end

export type BulletVfxInfo = {
	originPos: Vector3,
	goalPos: Vector3,
	theme: string,
}
packet.vfxRequest.OnServerEvent:Connect(function(player: Player, vfxName: string, info: BulletVfxInfo)
	info["shooter"] = player
	if vfxName == "BulletVFX" then
		packet.vfxRequest:Fire(vfxName, info)
	end
end)

export type gunModelInfo = {
	Owner: Player,
}
local lastGun = {}
packet.gunModelRequest.OnServerEvent:Connect(function(player: Player, gunName: string, info)
	local char = player.Character or player.CharacterAdded:Wait()

	if lastGun[char] :: Model then
		local gun = lastGun[char] :: Model
		for _, part in pairs(gun:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Transparency = 1
			end
		end
	end

	if not char:FindFirstChild(gunName) then
		local gunClone = assets.Models.Guns:WaitForChild(gunName):Clone() :: Model
		if not gunClone then
			return
		end
		gunClone.Parent = char
		gunClone:PivotTo(char["Right Arm"].RightGripAttachment.WorldCFrame)
		gunClone.Handle.WeldConstraint.Part1 = char["Right Arm"]
		lastGun[char] = gunClone
	else
		local gun = char[gunName]
		for _, part in pairs(gun:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Transparency = 0
			end
		end
		lastGun[char] = gun
	end
end)

return Shared
