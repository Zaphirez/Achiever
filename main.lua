-- ======================
--  Achiever - Main File
-- ======================
Achiever = Achiever or {}

local f = CreateFrame("Frame")
local timerFrame = CreateFrame("Frame")

local elapsed = 0
local playDelay = 1 -- seconds
local achievementQueue = {}
local isPlaying = false

-- ================================
--  Achievement Toast + Sound Logic
-- ================================

local function playAchieverSound()
    local rareID
    for _, achID in ipairs(achievementQueue) do
        if Achiever.RareAchievements[achID] then
            rareID = achID
            break
        end
    end

    if rareID then
        Achiever.playsound(Achiever.raresounds)
        ShowAchievementToast(rareID)
    else
        local lastID = achievementQueue[#achievementQueue]
        Achiever.playsound(Achiever.normalsounds)
        ShowAchievementToast(lastID)
    end

    -- Reset state
    achievementQueue = {}
    isPlaying = false
    elapsed = 0
    timerFrame:Hide()
end

timerFrame:SetScript("OnUpdate", function(_, delta)
    elapsed = elapsed + delta
    if elapsed >= playDelay then
        playAchieverSound()
    end
end)
timerFrame:Hide()

-- ===========================
--  Achievement Event Handling
-- ===========================

f:RegisterEvent("ACHIEVEMENT_EARNED")
f:RegisterEvent("PLAYER_LOGIN")

f:SetScript("OnEvent", function(_, event, id)
    if event == "ACHIEVEMENT_EARNED" then
        table.insert(achievementQueue, id)

        if not isPlaying then
            isPlaying = true
            elapsed = 0
            timerFrame:Show()
        end

    elseif event == "PLAYER_LOGIN" then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Achiever Loaded!|r")
        if AchieverSettings.lastNotifiedVersion and AchieverSettings.lastNotifiedVersion ~= Achiever.version then
            DEFAULT_CHAT_FRAME:AddMessage("Newer Version: " .. AchieverSettings.lastNotifiedVersion .. " available!")
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00" .. "Download it via https://github.com/Zaphirez/Achiever/releases/latest to stay up to date!")
        end
        
        if AchieverSettings.lastNotifiedVersion and not IsNewerVersion(Achiever.version, AchieverSettings.lastNotifiedVersion) then
            AchieverSettings.lastNotifiedVersion = nil
        end
    end
end)

-- =================
--  Slash Commands
-- =================

SLASH_ACHIEVER1 = "/achiever"
SlashCmdList["ACHIEVER"] = function(msg)
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    cmd = cmd:lower()

    if cmd == "test" and tonumber(arg) then
        local id = tonumber(arg)
        f:GetScript("OnEvent")(f, "ACHIEVEMENT_EARNED", id, Achiever.playerName)

    elseif cmd == "toggle" and Achiever.ToggleToast then
        Achiever.ToggleToast()

    elseif cmd == "status" and Achiever.IsToastEnabled then
        print("Toast is currently " .. (Achiever.IsToastEnabled() and "enabled." or "disabled."))

    elseif cmd == "version" then
        print("|cffaaff00Achiever|r v" .. Achiever.version .. " broadcasting version...")
        Achiever:Broadcast("VERSION:" .. Achiever.version)
    
    elseif cmd == "check" then
        Achiever:SendVersionCheck()

    else
        print("|cffffd700Achiever Addon Commands:")
        print("|cffffff00/achiever test <id>|r - Test achievement popup and sound.")
        print("|cffffff00/achiever toggle|r - Toggle achievement toast display on/off.")
        print("|cffffff00/achiever status|r - Check whether toast is enabled.")
        print("|cffffff00/achiever check|r - Asks players for their current version.")
        print("|cffffff00/achiever version|r - Broadcast your addon version.")
    end
end
