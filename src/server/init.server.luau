local players = game:GetService("Players")

local playerDataService = require(script.Services.PlayerDataService.PlayerDataServiceServer)

--[[
while true do
	for _, player in players:GetChildren() do
		playerDataService.Update(player, 1)
	end
	task.wait(1)
end
]]
