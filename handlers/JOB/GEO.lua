return {
	midcast = function(sets)
		if not sets.midcast then return false end
		---@type Action
		local ability = gFunc.GetAction()
		if ability.Type == 'Geomancy' then
			if sets.midcast.Geomancy then
				return sets.midcast.Geomancy
			end
		end
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