local runService = game:GetService("RunService")

local myServices = {}

myServices["Services"] = {}

function myServices:GetService(_serviceName)
	local getServiceAttempts = 3
	local attemptCooldown = 0.5

	local function attempt()
		for serviceName, serviceData in pairs(self["Services"]) do
			if serviceName == _serviceName then
				return serviceData
			end
		end
		return
	end

	for i = 1, getServiceAttempts, 1 do
		local attemptResult = attempt()

		if attemptResult then
			return attemptResult
		end

		task.wait(attemptCooldown)
	end
	return
end

function myServices:FetchAllServices(myServicesFolder: Folder)
	for _, serviceModule in pairs(myServicesFolder:GetDescendants()) do
		if serviceModule:IsA("ModuleScript") and serviceModule ~= script then
			local serviceName = serviceModule.Name
			local serviceData = require(serviceModule)

			if serviceData["Init"] then
				task.spawn(function()
					local initResult = serviceData:Init()

					if not initResult then
						--print('[MODULE LOADER]: Successfully initiated "'..serviceName..'" service')
						--else
						warn('[MODULE LOADER]: Error while initiating "' .. serviceName .. '" service')
					end
				end)
			end

			self["Services"][serviceName] = serviceData
		end
	end

	--end

	return myServices["Services"]
end

return myServices
