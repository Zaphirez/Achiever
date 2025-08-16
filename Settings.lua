local panel = CreateFrame("Frame")
panel.name = "Achiever"

-- Title
local Title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
Title:SetPoint("TOPLEFT", 16, -16)
Title:SetText("Achiever Settings")

-- Toast Checkbox
local showToastCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
showToastCheckbox:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -10)
showToastCheckbox.text = showToastCheckbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
showToastCheckbox.text:SetPoint("LEFT", showToastCheckbox, "RIGHT", 5, 0)
showToastCheckbox.text:SetText("Enable Achievement Toasts")

showToastCheckbox:SetScript("OnClick", function(self)
	AchieverSettings.showToast = self:GetChecked() and true or false
end)

local playSoundCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
playSoundCheckbox:SetPoint("TOPLEFT", showToastCheckbox, "BOTTOMLEFT", 0, -10)
playSoundCheckbox.text = playSoundCheckbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
playSoundCheckbox.text:SetPoint("LEFT", playSoundCheckbox, "RIGHT", 5, 0)
playSoundCheckbox.text:SetText("Enable Achievement Sounds")

playSoundCheckbox:SetScript("OnClick", function(self)
	AchieverSettings.soundEnabled = self:GetChecked() and true or false
end)

panel.refresh = function()
	showToastCheckbox:SetChecked(AchieverSettings.showToast)
	playSoundCheckbox:SetChecked(AchieverSettings.soundEnabled)
end

InterfaceOptions_AddCategory(panel)
