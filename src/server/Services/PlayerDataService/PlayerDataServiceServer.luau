local EncodingService = game:GetService("EncodingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TouchInputService = game:GetService("TouchInputService")
local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local ServerServices = game:GetService("ServerScriptService").Server.Services
local sharedServices = rs.Shared.Services
local shared = rs:WaitForChild("Shared")
local modules = shared.Modules

local ProfileStore = require(ReplicatedStorage.Packages.ProfileStore)
local defaultData = require(sharedServices.PlayerDataService.PlayerDataDefault)
local playerDataTemplate = defaultData.DEFAULT_PLAYER_DATA
local profileStore = require(rs.Packages.ProfileStore)
local packet = require(modules.Core.Packets)

local DATA_STORE_KEY = "Production"
if RunService:IsStudio() then
	DATA_STORE_KEY = "test1"
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
	--Alert the client
	if profile then
		packet.alertLoadedData:FireClient(player, profile.Data)
	end

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

function Shared.GetData(player: Player): defaultData.PlayerData?
	local profile = profiles[player]
	if not profile then
		return
	end

	return profile.Data
end

function Shared.Update(player: Player, num) end

packet.getPlayerDataPacket.OnServerInvoke = function(player)
	print("trying to send")
	local data = Shared.GetData(player)
	if not data then
		print("cant")
		return
	end
	return data
end

packet.updateSettings.OnServerEvent:Connect(function(player, name, value)
	local data = Shared.GetData(player)
	if not data or data.settings[name] == nil or typeof(value) ~= typeof(data.settings[name].Value) then
		return
	end

	local min = data.settings[name].Min
	local max = data.settings[name].Max
	if min ~= nil and value < min then
		data.settings[name].Value = min
	elseif max ~= nil and value > max then
		data.settings[name].Value = max
	else
		data.settings[name].Value = value
	end

	packet.updateSettingsAlert:FireClient(player)
	--print(`The new value of {name} is: `, data.settings[name].Value)
	return
end)

Local.OnStart()

return Shared
