return {
	midcast = function(action, sets)
		if sets.midcast == nil then return false end
		---@type Action
		if action.Name:contains('helix') then
			if sets.midcast.helix then
				return sets.midcast.helix
			end
		elseif action.Name:contains('storm') then
			if sets.midcast.storm then return sets.midcast.storm end
		end
	end
}