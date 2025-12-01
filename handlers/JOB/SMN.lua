return {
	default = function(sets, status) 
		if sets.general == nil or sets.general.pets == nil then return false end
		local PA = gData.GetPetAction()
		if PA == nil then return false end
		print(PA.Type)
		if PA.Type == 'Blood Pact: Rage' then
			
			return gFunc.Combine(
				sets.general.pets.default or {},
				sets.general.pets.bloodPact or {}
			)
		end
		return false
	end,
	ability = function(action, sets)
		if sets.ability == nil then return false end
		if action.Type == 'Blood Pact: Rage' or action.Type == 'Blood Pact: Ward' then
			return sets.ability.bloodPact or false
		end
		return false
	end
}