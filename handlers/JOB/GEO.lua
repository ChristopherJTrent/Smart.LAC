require('common')
return {
	default = function(sets, status) 
		local pet = gData.GetPet()
		if sets.general.geocolure and pet ~= nil then
			return sets.general.geocolure
		end
	end,
	midcast = function(action, sets)
		if not sets.midcast then return false end
		---@type Action
		local ability = action
		if string.match(ability.Name, 'Geo-') then
			if sets.midcast.geocolure then
				return sets.midcast.geocolure
			end
		end
		if string.match(ability.Name, 'Indi-') then
			if sets.midcast.indicolure then
				return sets.midcast.indicolure
			end
		end
		return false
	end
}