local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local packet = require(packages:WaitForChild("Packet"))

local Packets = {}

Packets.getPlayerDataPacket = packet("getPlayerDataPacket"):Response(packet.Any)
Packets.alertLoadedData = packet("alertLoadedData", packet.Any)

Packets.updateSettings = packet("updateSettings", packet.String, packet.Any) --Name, Value
Packets.updateSettingsAlert = packet("updateSettingsAlert")

Packets.shoot = packet("shoot", packet.Any, packet.Any, packet.String, packet.String):Response(packet.NumberS16) --Shooter/enemy/hitPart/gunName: response damage dealt

Packets.addSpeed = packet("addSpeed", packet.NumberS8, packet.NumberF24, packet.Boolean8) -- SpeedAdd, duration, airBoost?

Packets.useAbility = packet("useAbility", packet.Any) -- info
Packets.vfxRequest = packet("vfxRequest", packet.String, packet.Any) -- Name/Info

return Packets

--[[
	S8		Minimum: -128			Maximum: 127
	S16		Minimum: -32768			Maximum: 32767
	S24		Minimum: -8388608		Maximum: 8388607
	S32		Minimum: -2147483648	Maximum: 2147483647

	U8		Minimum: 0				Maximum: 255
	U16		Minimum: 0				Maximum: 65535
	U24		Minimum: 0				Maximum: 16777215
	U32		Minimum: 0				Maximum: 4294967295

	F16		±2048					[65520]
	F24		±262144					[4294959104]
	F32		±16777216				[170141183460469231731687303715884105728]
	F64		±9007199254740992		[huge]
]]
