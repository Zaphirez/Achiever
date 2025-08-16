-- 3.3.5a compat: C_Timer.After shim
if not C_Timer then
	C_Timer = {}
end
if not C_Timer.After then
	---@param delay integer
	---@param callback function
	function C_Timer.After(delay, callback)
		local f = CreateFrame("Frame")
		local t = 0
		f:SetScript("OnUpdate", function(self, elapsed)
			t = t + elapsed
			if t >= delay then
				self:SetScript("OnUpdate", nil)
				self:Hide()
				if type(callback) == "function" then
					callback()
				end
			end
		end)
	end
end
