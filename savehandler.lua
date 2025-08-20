-- ============================
--  Achiever Defaults
-- ============================

---@class Achiever
Achiever = Achiever or {}

--- Initializes the Default Settings stored ClientSide
function Achiever:InitDefaults()
	-- Version / Player info
	self.version = "1.3.1"
	self.playerName = self.playerName or UnitName("player")
	self.pendingChecks = self.pendingChecks or {}

	-- Saved variables
	---@class AchieverSettings
	AchieverSettings = AchieverSettings or {}
	AchieverSettings.lastNotifiedVersion = AchieverSettings.lastNotifiedVersion or nil
	AchieverSettings.soundEnabled = AchieverSettings.soundEnabled or true

	-- Toast Defaults
	AchieverSettings.Toast = AchieverSettings.Toast or {}

	AchieverSettings.Toast.TOAST_WIDTH = AchieverSettings.Toast.TOAST_WIDTH or 300
	AchieverSettings.Toast.TOAST_HEIGHT = AchieverSettings.Toast.TOAST_HEIGHT or 60
	AchieverSettings.Toast.TOAST_DURATION = AchieverSettings.Toast.TOAST_DURATION or 5
	AchieverSettings.Toast.TOAST_FADE_DURATION = AchieverSettings.Toast.TOAST_FADE_DURATION or 0.5
	AchieverSettings.Toast.Movable = AchieverSettings.Toast.Movable ~= nil and AchieverSettings.Toast.Movable or true

	-- Positionings
	AchieverSettings.Toast.Position = AchieverSettings.Toast.Position or {}

	AchieverSettings.Toast.Position.point = AchieverSettings.Toast.Position.point or "CENTER"
	AchieverSettings.Toast.Position.relativeTo = UIParent
	AchieverSettings.relativePoint = AchieverSettings.relativePoint or "CENTER"
	AchieverSettings.Toast.Position.xOfs = AchieverSettings.Toast.Position.xOfs or 0
	AchieverSettings.Toast.Position.yOfs = AchieverSettings.Toast.Position.yOfs or 0
end

-- ============================
--  Toast Helper Functions
-- ============================

--- Return Function for Toast State
--- @return boolean
Achiever.IsToastEnabled = function()
	return AchieverSettings.showToast ~= false
end

--- Return Function for Sound State
--- @return boolean
Achiever.IsSoundEnabled = function()
	return AchieverSettings.soundEnabled ~= false
end

--- Toggle Function for Toast Popup
Achiever.ToggleToast = function()
	AchieverSettings.showToast = not Achiever.IsToastEnabled()
	print("Achiever toast is now " .. (Achiever.IsToastEnabled() and "enabled." or "disabled."))
end

--- Toggle Function for Sound Player
Achiever.ToggleSound = function()
	AchieverSettings.soundEnabled = not Achiever.IsSoundEnabled()
	print("Achiever sound is now " .. (Achiever.IsSoundEnabled() and "enabled." or "disabled."))
end

-- ============================
--  ADDON_LOADED Hook
-- ============================

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, name)
	if name == "Achiever" then
		Achiever:InitDefaults()
	end
end)
