local globals = gFunc.LoadFile('globals.lua')
local helpers = gFunc.LoadFile('smart.lac/helpers.lua')

assert(globals ~= nil, "Globals unexpectedly nil")
assert(helpers ~= nil, "Helpers unexpectedly nil")

---@alias skillchainProp '"Transfixion"' | '"Compression"' | '"Liquefaction"' | '"Scission"' | '"Reverberation"' | '"Detonation"' | '"Induration"' | '"Impaction"' | '"Gravitation"' | '"Distortion"' | '"Fragmentation"' | '"Fusion"' | '"Light"' | '"Darkness"'

---@class util
---@field doBeltAndGorget fun(ability: skillchainData, data: playerData)

---@type table<string, skillchainData>
local applicableBelts = T{
	['Flame Belt']   = T{'Liquefaction', 'Fusion'},
	['Soil Belt']    = T{'Scission', 'Gravitation'},
	['Aqua Belt']    = T{'Reverberation', 'Distortion'},
	['Breeze Belt']  = T{'Detonation', 'Fragmentation'},
	['Snow Belt']    = T{'Induration', 'Distortion'},
	['Thunder Belt'] = T{'Impaction', 'Fragmentation'},
	['Light Belt']   = T{'Transfixion', 'Fusion', 'Light'},
	['Shadow Belt']  = T{'Compression', 'Gravitation', 'Darkness'}
}
---@type table<string, skillchainData>
local applicableGorgets = T{
	['Flame Gorget']   = T{'Liquefaction', 'Fusion'},
	['Soil Gorget']    = T{'Scission', 'Gravitation'},
	['Aqua Gorget']    = T{'Reverberation', 'Distortion'},
	['Breeze Gorget']  = T{'Detonation', 'Fragmentation'},
	['Snow Gorget']    = T{'Induration', 'Distortion'},
	['Thunder Gorget'] = T{'Impaction', 'Fragmentation'},
	['Light Gorget']   = T{'Transfixion', 'Fusion', 'Light'},
	['Shadow Gorget']  = T{'Compression', 'Gravitation', 'Darkness'}
}


---@param owned table<string, boolean>
---@param accessoryProperties table<string, skillchainData>
---@param ability skillchainData | number
---@param minimumLevel number
---@return string?
local getAccessoryForProperty = function(owned, accessoryProperties, ability, minimumLevel)
	if(type(ability) == "number") then ability = helpers.GetWeaponskillProperty({id = ability}) end
	if(gData.GetPlayer().MainJobLevel < minimumLevel) then return nil end
	if(owned['Fotia Belt']) then return 'Fotia Belt' end
	if(owned['Fotia Gorget']) then return 'Fotia Gorget' end
	---@type skillchainProp[]
	local skillchain = T(ability.skillchain)

	local found = nil

	for k, v in pairs(owned)do
		if v == true then
			for _, prop in ipairs(skillchain) do
				if T(accessoryProperties[k]):contains(prop) then
					found = k
					break
				end
			end
		end
	end

	if(found == nil and globals.debug) then print("Could not find accessory") end
	return found
end

---checks if an elemental belt with an appropriate property is owned.
---@return string?
---The first matching belt, or nil if none.
---@param belts table<string, boolean> Belts named K with boolean V Ownership
local getAppropriateBelt = function(belts, ability)
	return getAccessoryForProperty(belts, applicableBelts, ability, 87)
end

---checks if an elemental belt with an appropriate property is owned.
---@return string?
---The first matching belt, or nil if none.
---@param gorgets table<string, boolean> 
---Belts named K with boolean V Ownership
local getAppropriateGorget = function(gorgets, ability)
	return getAccessoryForProperty(gorgets, applicableGorgets, ability, 72)
end

local doBelt = function(ability, data)
	local belt = getAppropriateBelt(data.ownedBelts, ability)
	if (belt ~= nil) then
		if(globals.debug) then print("Found belt "..belt.." for ability "..ability.en) end
		gFunc.EquipSet({Waist = belt})
	end
end
local doGorget = function(ability, data)
	local gorget = getAppropriateGorget(data.ownedGorgets, ability)
	if (gorget ~= nil) then
		gFunc.EquipSet({Neck = gorget})
	end
end

---@type accessories
return {
	DoBelt = doBelt,
	DoGorget = doGorget,
	DoBeltAndGorget = function (ability, data)
		doBelt(ability, data)
		doGorget(ability, data)
	end
}