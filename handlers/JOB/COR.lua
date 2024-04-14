return {
	ability = function(action, sets)
		if (string.match(action.Name, 'Roll')) then
			if(sets['ability'].phantomRoll) then
				gFunc.EquipSet(sets.ability.phantomRoll)
				return false
			end
		end
		return false
	end
}