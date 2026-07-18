require('common')
return T{
	midcast = function(action, sets)
		-- Thanks to Arieh for these lists.
		local barSpells = T{
			'Barfira', -- this looks weird, but this data change makes the code much easier to write.
			'Barblizzara', --this table is effectively an array with two extra tables stapled onto the end.
			'Baraera',
			'Barstonra',
			'Barthundra',
			'Barwatera',
			'Baramnesra',
			'Barvira',
			'Barparalyzra',
			'Barsilencera',
			'Barpetra',
			'Barpoisonra',
			'Barblindra',
			'Barsleepra',
			['element'] = T{'Barfira', 'Barblizzara', 'Baraera', 'Barstonra', 'Barthundra', 'Barwatera'},
			['status'] = T{'Baramnesra', 'Barvira', 'Barparalyzra', 'Barsilencera', 'Barpetra', 'Barpoisonra', 'Barblindra', 'Barsleepra'},
		}
		local naSpells = T{'Blindna', 'Esuna', 'Paralyna', 'Poisona', 'Silena', 'Stona', 'Viruna'}
		if sets.midcast then
			local finalSet = sets.midcast.default or {}
			if sets.midcast.barSpell and barSpells:contains(action.Name) then
				finalSet = gFunc.Combine(finalSet, sets.midcast.barSpell)
			end
			if sets.midcast.barElement and barSpells.element:contains(action.Name) then
				finalSet = gFunc.Combine(finalSet, sets.midcast.barElement)
			elseif sets.midcast.barStatus and barSpells.status:contains(action.Name) then
				finalSet = gFunc.Combine(finalSet, sets.midcast.barStatus)
			end
			if sets.midcast.naSpell and naSpells:contains(action.Name) then
				finalSet = gFunc.Combine(finalSet, sets.midcast.naSpell)
			end
			return finalSet
		end
		return false
	end
}
