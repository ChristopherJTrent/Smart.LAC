return {
	ability = function(action, sets)
		print('ability handler called')
		if (action.Type == 'Corsair Roll' or action.Name == 'Double-Up') then
			if(sets['ability'].phantomRoll) then
				print('returning PR set')
				return sets.ability.phantomRoll
			end
		end
		return false
	end
}