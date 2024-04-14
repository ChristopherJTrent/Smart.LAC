local globals = gFunc.LoadFile('globals.lua')
local helpers = gFunc.LoadFile('smart.lac/helpers.lua')
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
	if(type(ability) == "number") then ability = helpers.getWeaponskillProperties({id = ability}) end
	if(gData.GetPlayer().MainJobLevel < minimumLevel) then return nil end
	if(owned['Fotia Belt']) then return 'Fotia Belt' end
	if(owned['Fotia Gorget']) then return 'Fotia Gorget' end
	---@type skillchainProp[]
	local skillchain = ability.skillchain
	--filter the list of accessory properties by ownership	
	local found = accessoryProperties:intersect(
				owned:filter(function(v) 
					return v
				end))
				--transform that list into a list of owned accessories with appropriate property
				:map(function(v)
					return v:intersect(skillchain):length() > 0
				end)
				:keys()
				:first()
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
		gFunc.Equip('Waist', {name = belt})
	end
end
local doGorget = function(ability, data)
	local gorget = getAppropriateGorget(data.ownedGorgets, ability)
	if (gorget ~= nil) then
		gFunc.Equip('Neck', {name = gorget})
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