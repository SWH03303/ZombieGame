local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local packet = require(packages:WaitForChild("Packet"))

local Shared = {}

Shared.getPlayerDataPacket = packet("getPlayerDataPacket"):Response(packet.Any)
Shared.alertLoadedData = packet("alertLoadedData", packet.Any)

Shared.updateSettings = packet("updateSettings", packet.String, packet.Any) --Name, Value
Shared.updateSettingsAlert = packet("updateSettingsAlert")

return Shared
