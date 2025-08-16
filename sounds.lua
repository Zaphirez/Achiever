Achiever = Achiever or {}
local basepath = "Interface\\AddOns\\Achiever\\Sounds\\"
local rarepath = basepath .. "Rare\\"
local normpath = basepath .. "Normal\\"

Achiever.raresounds = {
	rarepath .. "FinalFantasy1.mp3",
	rarepath .. "FinalFantasy.mp3",
	rarepath .. "FFXI.mp3",
	rarepath .. "Proof-Of-A-Hero.mp3",
}

Achiever.normalsounds = {
	normpath .. "Pokemon.mp3",
	normpath .. "Diablo2Lvlup.mp3",
	normpath .. "xboxonerareachievement.mp3",
}

--- Randomly play a sound from the provided list
---@param list table
function Achiever.playsound(list)
	if not Achiever.IsSoundEnabled() then
		return
	end

	if not list or #list == 0 then
		print("Achiever: No sounds available in the provided list.")
		return
	end

	local index = math.random(#list)
	local path = list[index]

	if path then
		PlaySoundFile(path, "Master") -- "Master" plays even if sound effects are off
	else
		print("Achiever: Failed to retrieve sound path.")
	end
end
