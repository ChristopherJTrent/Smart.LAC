return {
	default = function(sets, state)
		if sets.general == nil or sets.general.pets == nil then return false end
		local PA = gData.GetPetAction()
		if PA == nil then return false end
		if sets.general.pets.default == nil and sets.general.pets[PA.Name] == nil then
			return false
		end
		local finalSet = sets.general.pets.default or {}
		if PA.ActionType == 'MobSkill' and sets.general.pets[PA.Name] ~= nil then
			finalSet = gFunc.Combine(finalSet, sets.general.pets[PA.Name])
		end
		return finalSet
	end
}