Achiever = Achiever or {}
AchieverSettings = AchieverSettings or {}

-- Saves
Achiever.IsToastEnabled = function ()
    return AchieverSettings.showToast ~= false
end

Achiever.ToggleToast = function ()
    AchieverSettings.showToast = not Achiever.IsToastEnabled()
    print("Achiever toast is now " .. (Achiever.IsToastEnabled() and "enabled." or "disabled." ))
end
