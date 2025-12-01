return {
	default = function(sets, status)
		local pet = gData.GetPet()
		if pet == nil then return false end
		if sets.general == nil or  sets.general.pets == nil then return false end
		if sets.general.pets.weaponskill
			and pet.TP > 950
			and pet.Status == 'Engaged'
		then
			return sets.general.pets.weaponskill
		end
	end
}