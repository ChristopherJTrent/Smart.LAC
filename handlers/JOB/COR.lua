return {
	ability = function(action, sets)
		if (action.Type == 'Corsair Roll' or action.Name == 'Double-Up') then
			if(sets['ability'].phantomRoll) then
				return sets.ability.phantomRoll
			end
		elseif (action.Type == "Quick Draw") then
			if (sets.ability.quickDraw) then
				return sets.ability.quickDraw
			end
		end
		return false
	end
}