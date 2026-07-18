require('common')
return {
	midcast = function(action, sets) 
		if sets.midcast == nil or sets.midcast.enmity == nil then return false end
		local hatespells = T{
			"Blank Gaze",
			"Jettatura",
			"Sheep Song",
			"Stinking Gas",
			"Geist Wall",
			"Soporific",
			"Cold Wave"
		}
		if hatespells:contains(action.Name) then
			return sets.midcast.enmity
		end
	end
}