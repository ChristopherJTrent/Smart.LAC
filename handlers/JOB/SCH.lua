require('common')
return {
	precast = function(action, sets)
		local currentArts = (gData.GetBuffCount("Light Arts") == 1 or gData.GetBuffCount("Addendum: White") == 1) and "White Magic" or "Black Magic"
		if action.Type ~= currentArts then
			if sets.precast and sets.precast.wrongarts then
				return sets.precast.wrongarts
			end
		end
		return false
	end,
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