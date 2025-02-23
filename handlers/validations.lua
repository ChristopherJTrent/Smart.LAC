local helpers = gFunc.LoadFile('smart.lac/helpers.lua')

assert(helpers ~= nil, "Helpers unexpectedly nil")

local validations = {}

function validations.checkForDefaults(sets)
	local success = true
	for k, v in pairs(sets) do
		if v.default == nil and (k ~= 'general' and k ~= 'settings' and k ~= 'lockstyle') and not k:find("^_") then
			success = false
			if v.Default ~= nil then
				print(chat.warning(helpers.AddModHeader('Found key "Default" in table '..k..', did you mean "default"?')))
			else
				print(chat.warning(helpers.AddModHeader('Table '..k..' is missing a "default" set. All defined set tables should have a default.')))
			end
		end
	end
	return success
end


function validations.validateGeneral(sets)
	if sets.general then
		if sets.general.Idle == nil then
			if sets.general.idle then
				print(helpers.AddModHeader(chat.warning('found set "general.idle", did you mean "general.Idle"?')))
			else
				print(helpers.AddModHeader(chat.warning('Idle set not found')))
			end
		else
			return true
		end
	elseif sets.General then
		print(helpers.AddModHeader(chat.warning('found set "General", did you mean "general"?')))
	else
		print(helpers.AddModHeader(chat.warning('general table not found, please add one.')))
	end
	return false
end

function validations.validate(sets)
	return validations.checkForDefaults(sets) and validations.validateGeneral(sets)
end

return validations