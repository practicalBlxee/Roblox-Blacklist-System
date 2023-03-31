local players = game:GetService("Players")
local blacklistURL = "https://raw.githubusercontent.com/practicalBlxee/Roblox-Blacklist-System/main/blacklist.json"
local blacklistedUsers = {}
local isCoroutineCompleted = false

-- retrieve data from url asynchronously
coroutine.wrap(function()
	local blacklistData = game.HttpService:GetAsync(blacklistURL)
	blacklistedUsers = game:GetService("HttpService"):JSONDecode(blacklistData)
	isCoroutineCompleted = true

	-- loop through existing players and check if they are blacklisted
	for _, player in ipairs(players:GetPlayers()) do
		isBlacklisted(player)
	end
end)()

local function isBlacklisted(player)
	-- check if coroutine has completed
	while not isCoroutineCompleted do
		wait()
	end
	print(blacklistedUsers["blacklisted"])
	for _, user in ipairs(blacklistedUsers["blacklisted"]) do
print(player.UserId)
		if user.id == player.UserId then
			if user.alt == true then
				player:Kick("BLACKLIST SYSTEM \n\n BLACKLISTED. \n REASON: Your primary account has already been blacklisted for " .. user.reason .. ".\nThis does not expire.")
			end
			if user.alt == false then 
				player:Kick("BLACKLIST SYSTEM \n\n BLACKLISTED. \n REASON: " .. user.reason .. ".\nThis does not expire.")
			end
			return true
		end
	end
	return false
end

-- check if new players are blacklisted
players.PlayerAdded:Connect(function(player)
	-- check if coroutine has completed
	while not isCoroutineCompleted do
		wait()
	end

	if isBlacklisted(player) then
		return
	end
end)

-- continuously check for blacklisted players
while true do
	-- check if coroutine has completed
	while not isCoroutineCompleted do
		wait()
	end

	wait(20)
	for _, player in ipairs(players:GetPlayers()) do
		isBlacklisted(player)
	end
end
