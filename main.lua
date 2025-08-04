-- ======================
--  Achiever - Main File
-- ======================

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
        print("|cff00ff00Achiever Loaded!|r")
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
        local player = UnitName("player")
        f:GetScript("OnEvent")(f, "ACHIEVEMENT_EARNED", id, player)

    elseif cmd == "toggle" then
        Achiever.ToggleToast()

    elseif cmd == "status" then
        print("Toast is currently " .. (Achiever.IsToastEnabled() and "enabled." or "disabled."))

    else
        print("|cffffd700Achiever Addon Commands:")
        print("|cffffff00/achiever test <id>|r - Test achievement popup and sound.")
        print("|cffffff00/achiever toggle|r - Toggle achievement toast display on/off.")
        print("|cffffff00/achiever status|r - Check whether toast is enabled.")
    end
end
