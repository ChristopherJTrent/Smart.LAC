return {
	default = function(sets, state)
		if sets.general == nil or sets.general.pets == nil then return false end
		local PA = gData.GetPetAction()
		if PA == nil then return false end
		local finalSet = sets.general.pets.default or {}
		if PA.ActionType == 'MobSkill' then
			finalSet = gFunc.Combine(finalSet, sets.general.pets[PA.Name])
		end
		if finalSet == {} then
			return false
		end
		return finalSet
	end
}