Achiever = Achiever or {}
AchieverSettings = AchieverSettings or {}

-- Version comparison function
function IsNewerVersion(a, b)
	local function split(v)
		local major, minor, patch = string.match(v, "(%d+)%.(%d+)%.(%d+)")
		return tonumber(major), tonumber(minor), tonumber(patch)
	end

	local a1, a2, a3 = split(a)
	local b1, b2, b3 = split(b)

	if a1 ~= b1 then
		return a1 > b1
	end
	if a2 ~= b2 then
		return a2 > b2
	end
	return a3 > b3
end

function GetAvailableChannels()
	local available = {}

	if IsInGuild() then
		table.insert(available, "GUILD")
	end

	if UnitInParty("player") then
		table.insert(available, "PARTY")
	end

	if UnitInRaid("player") then
		table.insert(available, "RAID")
	end

	if UnitInBattleground("player") then
		table.insert(available, "BATTLEGROUND")
	end

	-- You could also check joined custom channels
	--[[     for i = 1, GetNumDisplayChannels() do
        local name, _, _, _, _, _, channelID = GetChannelDisplayInfo(i)
        if name then
            table.insert(available, channelID)
            -- You’d pass the numeric ID when using SendAddonMessage for CHANNEL
        end
    end ]]

	return available
end

function Achiever:Broadcast(txt, channel)
	if not txt or txt == "" then
		return
	end
	local channel = channel or nil
	local channels = GetAvailableChannels()
	--print(txt)
	--print(channel)

	if #txt > 255 then
		DEFAULT_CHAT_FRAME:AddMessage("Achiever.Broadcast: Message too long! Max 255 Chars!")
		return
	end

	if channel then
		for _, ch in ipairs(channels) do
			if channel == ch then
				SendAddonMessage("Achiever", txt, channel)
				-- DEFAULT_CHAT_FRAME:AddMessage("Achiever send message into " .. channel .. ".")
				return
			end
		end
		DEFAULT_CHAT_FRAME:AddMessage("Achiever.Broadcast: Invalid Channel! " .. channel)
		return
	end

	for _, ch in ipairs(channels) do
		SendAddonMessage("Achiever", txt, ch)
		return
	end

	DEFAULT_CHAT_FRAME:AddMessage("Achiever.Broadcast: No Channels Found!")
end

-- Event frame
local versionFrame = CreateFrame("Frame")
versionFrame:RegisterEvent("PLAYER_LOGIN")
versionFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
versionFrame:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" or event == "GROUP_ROSTER_UPDATE" then
		Achiever:Broadcast("VERSION:" .. Achiever.version)
	end
end)

-- Register Addon Message listener

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")

-- Broadcasting a check request
function Achiever:SendVersionCheck()
	local checkID = math.random(99999)
	self.pendingChecks[checkID] = {}

	DEFAULT_CHAT_FRAME:AddMessage("|cffaaff00Achiever:|r Sending check (ID: " .. checkID .. ")...")
	self:Broadcast(("CHECK:" .. tostring(checkID)))
end

-- Handle Incoming messages
f:SetScript("OnEvent", function(_, _, prefix, msg, channel, sender)
	if prefix ~= "Achiever" or sender == Achiever.playerName then
		return
	end

	-- Debug
	-- print(prefix, msg, channel, sender)

	-- Check Request
	local checkID = msg:match("^CHECK:(%d+)$")
	if checkID then
		Achiever:Broadcast("RESPONSE:" .. checkID .. ":" .. Achiever.version, channel)
		return
	end

	local respCheckID, theirVersion = msg:match("^RESPONSE:(%d+):(.+)$")
	if respCheckID and theirVersion then
		respCheckID = tonumber(respCheckID)
		if Achiever.pendingChecks[respCheckID] then
			Achiever.pendingChecks[respCheckID][sender] = theirVersion
			DEFAULT_CHAT_FRAME:AddMessage(
				"|cffaaff00Achiever:|r " .. sender .. " responded with version " .. theirVersion
			)
			--[[         else
            DEFAULT_CHAT_FRAME:AddMessage("No pending check found for CheckID:", respCheckID) ]]
		end
		return
	end

	local theirVersionPassive = msg:match("^VERSION:(.+)")
	if theirVersionPassive then
		-- print("|cffaaff00Achiever:|r Received version " .. theirVersionPassive .. " from " .. sender) -- Debug
		if
			IsNewerVersion(theirVersionPassive, Achiever.version)
			and AchieverSettings.lastNotifiedVersion ~= theirVersionPassive
		then
			DEFAULT_CHAT_FRAME:AddMessage(
				"|cffffaa00Achiever:|r New version available (v" .. theirVersionPassive .. ") from " .. sender
			)
			DEFAULT_CHAT_FRAME:AddMessage(
				"|cffffaa00"
					.. "Achiever:"
					.. "|r"
					.. "You can download it from "
					.. "https://github.com/Zaphirez/Achiever/releases/latest"
			)
			AchieverSettings.lastNotifiedVersion = theirVersionPassive
		end
		return
	end
end)
