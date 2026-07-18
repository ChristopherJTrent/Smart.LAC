return {
	default = function(sets, status)
		local pet = gData.GetPet()
		if pet == nil or pet.Status ~= 'Engaged' then return false end
		if sets.general == nil or  sets.general.pets == nil then return false end
		if (sets.general.pets.weaponskill ~= nil)
			and (pet.TP > 950)
		then
			return sets.general.pets.weaponskill
		else
			return false
		end
	end
}