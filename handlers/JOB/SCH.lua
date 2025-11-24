require('common')
return {
	midcast = function(action, sets)
		if sets.midcast == nil then return false end
		---@type Action
		if string.find(action.Name, 'helix') ~= nil then
			if sets.midcast.helix then
				return sets.midcast.helix
			end
		elseif string.find(action.Name, 'storm') then
			if sets.midcast.storm then return sets.midcast.storm end
		end
	end
}