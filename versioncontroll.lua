Achiever = Achiever or {}

Achiever.version = "1.1.1"
Achiever.lastNotifiedVersion = nil
Achiever.playerName = UnitName("player") or "Unknown"

-- Version comparison function
local function IsNewerVersion(a, b)
    local function split(v)
        local major, minor, patch = string.match(v, "(%d+)%.(%d+)%.(%d+)")
        return tonumber(major), tonumber(minor), tonumber(patch)
    end

    local a1, a2, a3 = split(a)
    local b1, b2, b3 = split(b)

    if a1 ~= b1 then return a1 > b1 end
    if a2 ~= b2 then return a2 > b2 end
    return a3 > b3
end

-- Broadcast version info
function Achiever.Achiever_BroadcastVersion()
    local channels = {}

    if GetNumRaidMembers() > 0 then
        table.insert(channels, "RAID")
    end
    if GetNumPartyMembers() > 0 then
        table.insert(channels, "PARTY")
    end

    for _, channel in ipairs(channels) do
        SendAddonMessage("Achiever", "VERSION:" .. Achiever.version, channel)
    end
end

-- Event frame
local versionFrame = CreateFrame("Frame")
versionFrame:RegisterEvent("PLAYER_LOGIN")
versionFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
versionFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" or event == "GROUP_ROSTER_UPDATE" then
        Achiever.Achiever_BroadcastVersion()
    end
end)

-- Register Addon Message listener

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")
f:SetScript("OnEvent", function(_, _, prefix, msg, channel, sender)
    if prefix ~= "Achiever" or sender == Achiever.playerName then return end

    local theirVersion = msg:match("^VERSION:(.+)")
    if theirVersion then
        -- print("|cffaaff00Achiever:|r Received version " .. theirVersion .. " from " .. sender) -- Debug
        if IsNewerVersion(theirVersion, Achiever.version) and Achiever.lastNotifiedVersion ~= theirVersion then
            print("|cffffaa00Achiever:|r New version available (v" .. theirVersion .. ") from " .. sender)
            Achiever.lastNotifiedVersion = theirVersion
        end
    end
end)
