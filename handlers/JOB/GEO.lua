return {
	midcast = function(sets)
		if not sets.midcast then return false end
		---@type Action
		local ability = gFunc.GetAction()
		if string.match(ability.Name, 'Geo-') then
			print ("geocolure")
			if sets.midcast.geocolure then
				gFunc.EquipSet(sets.midcast.geocolure)
				return true
			end
		end
		if string.match(ability.Name, 'Indi-') then
			print('indicolure')
			if sets.midcast.indicolure then
				gFunc.EquipSet(sets.midcast.indicolure)
				return true
			end
		end
		return false
	end
}