-- ============================
--  Achiever Toast Frame Setup
-- ============================

local TOAST_WIDTH = 300
local TOAST_HEIGHT = 60
local TOAST_DURATION = 3         -- seconds before fading
local TOAST_FADE_DURATION = 0.5  -- fade-out time

toast = CreateFrame("Frame", "AchieverToastFrame", UIParent)
toast:SetSize(TOAST_WIDTH, TOAST_HEIGHT)
toast:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, 10)
toast:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
toast:SetFrameStrata("HIGH")
toast:SetFrameLevel(100)
toast:SetScale(UIParent:GetScale())
toast:Hide()

-- ==================
--  Toast Components
-- ==================

-- Icon
toast.icon = toast:CreateTexture(nil, "ARTWORK")
toast.icon:SetSize(48, 48)
toast.icon:SetPoint("LEFT", 10, 0)

-- Achievement Name Text
toast.text = toast:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
toast.text:SetPoint("LEFT", toast.icon, "RIGHT", 10, 0)
toast.text:SetJustifyH("LEFT")
toast.text:SetWidth(220)
toast.text:SetWordWrap(false)

-- Internal state
toast.timer = 0
toast.fadeTimer = 0
toast.countinit = false
toast.fadingOut = false

-- ==========================
--  ShowAchievementToast(id)
-- ==========================

function ShowAchievementToast(achievementID)
    if not Achiever.IsToastEnabled() then return end

    local id, name, points, completed, month, day, year, description, flags,
          icon, rewardText, isGuild, wasEarnedByMe, earnedBy, isStatistic = GetAchievementInfo(achievementID)

    if not name then return end

    toast.icon:SetTexture(icon or "Interface\\Icons\\Achievement_General")
    toast.text:SetText(name)

    toast.countinit = true
    toast.timer = 0
    toast.fadeTimer = 0
    toast.fadingOut = false
    toast:SetAlpha(0)
    toast:Show()

    UIFrameFadeIn(toast, 0.5, 0, 1)
end

-- ====================
--  OnUpdate Timer Tick
-- ====================

toast:SetScript("OnUpdate", function(self, delta)
    if self.countinit then
        self.timer = self.timer + delta

        if self.timer > TOAST_DURATION then
            self.countinit = false
            self.fadingOut = true
            self.fadeTimer = 0
        end
    end

    if self.fadingOut then
        self.fadeTimer = self.fadeTimer + delta
        local alpha = 1 - (self.fadeTimer / TOAST_FADE_DURATION)

        if alpha <= 0 then
            self:Hide()
            self:SetAlpha(1)
            self.fadingOut = false
        else
            self:SetAlpha(alpha)
        end
    end
end)
