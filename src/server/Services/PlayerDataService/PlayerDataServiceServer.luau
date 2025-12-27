local EncodingService = game:GetService("EncodingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TouchInputService = game:GetService("TouchInputService")
local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local ServerServices = game:GetService("ServerScriptService").Server.Services
local sharedServices = rs.Shared.Services
local ProfileStore = require(ReplicatedStorage.Packages.ProfileStore)
local PlayerDataServiceClient = require(ReplicatedStorage.Shared.Services.PlayerDataService.PlayerDataServiceClient)
local clientService = require(sharedServices.PlayerDataService.PlayerDataServiceClient)

local playerDataTemplate = clientService.DEFAULT_PLAYER_DATA
local profileStore = require(rs.Packages.ProfileStore)

local DATA_STORE_KEY = "Production"
if RunService:IsStudio() then
	DATA_STORE_KEY = "Test"
end

local playerStore = ProfileStore.New(DATA_STORE_KEY, playerDataTemplate)
local profiles: { [player]: typeof(playerStore:StartSessionAsync()) } = {}

local Local = {}
local Shared = {}

function Local.OnStart()
	for _, player in players:GetPlayers() do
		task.spawn(Local.LoadProfile, player)
	end
	players.PlayerAdded:Connect(Local.LoadProfile)
	players.PlayerRemoving:Connect(Local.RemoveProfile)
end

function Local.LoadProfile(player: Player)
	local profile = playerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= players
		end,
	})

	if profile == nil then
		return player:Kick("Profile loaded fail.")
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()

	profile.OnSessionEnd:Connect(function()
		profiles[player] = nil
		player:Kick("Profile session ended")
	end)

	local isInGame = player.Parent == players
	if isInGame then
		profiles[player] = profile
	else
		profile:EndSession()
	end

	return
end

function Local.RemoveProfile(player: Player)
	local profile = profiles[player]
	if profile ~= nil then
		profile:EndSession()
	end
end

function Shared.GetData(player: Player): PlayerDataServiceClient.PlayerData?
	local profile = profiles[player]
	if not profile then
		return
	end

	return profile.Data
end

function Shared.Update(player: Player, num)
	local data = Shared.GetData(player)
	if not data then
		return
	end

	local sensitivity = data.settings.sensitivity
	data.settings.sensitivity += num

	print(Shared.GetData(player))
end

Local.OnStart()

return Shared
