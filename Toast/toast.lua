-- ============================
--  Achiever Toast Frame Setup
-- ============================

local addonName = ...
toast = CreateFrame("Frame", "AchieverToastFrame", UIParent)
toast:Hide()

toast:RegisterEvent("ADDON_LOADED")
toast:SetScript("OnEvent", function(self, event, name)
	if name ~= addonName then
		return
	end

	-- Initialize defaults (your function sets AchieverSettings)
	Achiever:InitDefaults()

	-- Apply settings
	self:SetSize(AchieverSettings.Toast.TOAST_WIDTH, AchieverSettings.Toast.TOAST_HEIGHT)
	self:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, 10)
	self:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 8, right = 8, top = 8, bottom = 8 },
	})
	self:SetFrameStrata("HIGH")
	self:SetFrameLevel(100)
	self:SetScale(UIParent:GetScale())
	self:SetMovable(true)
	self:EnableMouse(true)
	self:RegisterForDrag("LeftButton")
	self:SetClampedToScreen(true)

	-- Dragging
	self:SetScript("OnDragStart", self.StartMoving)
	self:SetScript("OnDragStop", function(frame)
		frame:StopMovingOrSizing()

		local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
		AchieverSettings.Toast.Position = {
			point = point or "CENTER",
			relativeTo = relativeTo,
			relativePoint = relativePoint or "CENTER",
			xOfs = xOfs or 0,
			yOfs = yOfs or 0,
		}
	end)

	-- ==================
	--  Toast Components
	-- ==================

	-- Icon
	self.icon = self:CreateTexture(nil, "ARTWORK")
	self.icon:SetSize(48, 48)
	self.icon:SetPoint("LEFT", 10, 0)

	-- Achievement Name Text
	self.text = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	self.text:SetPoint("LEFT", self.icon, "RIGHT", 10, 0)
	self.text:SetJustifyH("LEFT")
	self.text:SetWidth(220)
	self.text:SetWordWrap(false)

	-- Internal state
	self.timer = 0
	self.fadeTimer = 0
	self.countinit = false
	self.fadingOut = false

	-- Done initializing
	self:UnregisterEvent("ADDON_LOADED")
end)

-- ==========================
--  ShowAchievementToast(id)
-- ==========================

---@param achievementID integer
---@param rare boolean
function ShowAchievementToast(achievementID, rare)
	if not Achiever.IsToastEnabled() then
		return
	end
	rare = rare or false

	local id, name, points, completed, month, day, year, description, flags, icon, rewardText, isGuild, wasEarnedByMe, earnedBy, isStatistic =
		GetAchievementInfo(achievementID)

	if not name then
		return
	end

	toast.icon:SetTexture(icon or "Interface\\Icons\\Achievement_General")
	toast.text:SetText(name)

	toast.countinit = true
	toast.timer = 0
	toast.fadeTimer = 0
	toast.fadingOut = false
	toast:SetAlpha(0)

	toast:ClearAllPoints()
	toast:SetPoint(
		AchieverSettings.Toast.Position.point or "CENTER",
		AchieverSettings.Toast.Position.relativeTo or UIParent,
		AchieverSettings.Toast.Position.relativePoint or "CENTER",
		AchieverSettings.Toast.Position.xOfs or 0,
		AchieverSettings.Toast.Position.yOfs or 0
	)

	if rare then
		toast:SetBackdropBorderColor(1, 0.84, 0, 1) -- gold border
	else
		toast:SetBackdropBorderColor(1, 1, 1, 1) -- reset to white
	end

	toast:Show()
	UIFrameFadeIn(toast, AchieverSettings.Toast.TOAST_FADE_DURATION, 0, 1)

	C_Timer.After(AchieverSettings.Toast.TOAST_DURATION, function()
		UIFrameFadeOut(toast, AchieverSettings.Toast.TOAST_FADE_DURATION, 1, 0)
		C_Timer.After(AchieverSettings.Toast.TOAST_FADE_DURATION, function()
			toast:Hide()
		end)
	end)
end
