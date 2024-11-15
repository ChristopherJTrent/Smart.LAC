local helpers = gFunc.LoadFile('smart.lac/helpers.lua')

local function CheckForDefaults(sets)
	for k, v in pairs(sets) do
		if v.default == nil and (k ~= 'general' and k ~= 'settings' and k ~= 'lockstyle') and not k:find("^_") then
			if v.Default ~= nil then
				print(chat.warning(helpers.AddModHeader('Found key "Default" in table '..k..', did you mean "default"?')))
			else
				print(chat.warning(helpers.AddModHeader('Table '..k..' is missing a "default" set. All defined set tables should have a default.')))
			end
		end
	end
end


local function validateGeneral(sets)
	if sets.general then
		if sets.general.Idle == nil then
			if sets.general.idle then
				print(helpers.AddModHeader(chat.warning('found set "general.idle", did you mean "general.Idle"?')))
			else
				print(helpers.AddModHeader(chat.warning('Idle set not found')))
			end
		end
	elseif sets.General then
		print(helpers.AddModHeader(chat.warning('found set "General", did you mean "general"?')))
	else
		print(helpers.AddModHeader(chat.warning('general table not found, please add one.')))
	end
end

local function root(sets)
	validateGeneral(sets)
	CheckForDefaults(sets)
end

return root