local validations = {}
function validations.ensureExistence(sets)
	if sets == nil then
		print(chat.error(Helpers.AddModHeader('Your sets table should not be nil.')))
		return false
	end
	return true
end
function validations.CheckForDefaults(sets)
	local success = true
	for k, v in pairs(sets) do
		if v.default == nil and (k ~= 'general' and k ~= 'settings' and k ~= 'lockstyle') and not k:find("^_") then
			success = false
			if v.Default ~= nil then
				print(chat.warning(Helpers.AddModHeader('Found key "Default" in table '..k..', did you mean "default"?')))
			else
				print(chat.warning(Helpers.AddModHeader('Table '..k..' is missing a "default" set. All defined set tables should have a default.')))
			end
		end
	end
	return success
end


function validations.validateGeneral(sets)
	if sets.general then
		if sets.general.Idle == nil then
			if sets.general.idle then
				print(Helpers.AddModHeader(chat.warning('found set "general.idle", did you mean "general.Idle"?')))
			else
				print(Helpers.AddModHeader(chat.warning('Idle set not found')))
			end
		else
			return true	
		end
	elseif sets.General then
		print(Helpers.AddModHeader(chat.warning('found set "General", did you mean "general"?')))
	else
		print(Helpers.AddModHeader(chat.warning('general table not found, please add one.')))
	end
	return false
end

function validations.validate(sets)
	return validations.CheckForDefaults(sets) and validations.validateGeneral(sets) and validations.ensureExistence(sets)
end

setmetatable(validations, {
	__call = function (t, sets)
		return t.validate(sets)
	end
})

return validations