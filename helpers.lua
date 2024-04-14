local skills = gFunc.LoadFile('smart.lac/data/skills.lua')

---@param sets sets
---@param key string
---@param overrides set
local function EquipWithDefault(sets, key, overrides)
	if sets[key].default == nil then return nil end
	local combined = gFunc.Combine(sets[key].default, overrides)
	gFunc.EquipSet(combined)
end

local function EnsureSugaredTable(t)
	if(not t.contains) then
		return T(t)
	end
	return t
end

local function ContainsAllKeys(t, other)
	for k, _ in ipairs(t) do
		if(not other.containskey) then T(other) end
		if(not other:containskey(k)) then
			return false
		end
	end
	return true
end

local function ValidatePlayerData(t)
	---@type playerData
	local validData = gFunc.LoadFile('smart.lac/data/index.lua')
	---@type globals
	local globals = gFunc.LoadFile('globals.lua')
	local belts = ContainsAllKeys(validData.ownedBelts, t.ownedBelts)
	local gorgets = ContainsAllKeys(validData.ownedGorgets, t.ownedGorgets)
	if(globals.debug) then
		print("Belts: "..(belts and "true" or "false"))
		print("Gorgets: "..(gorgets and "true" or "false"))
	end
	return belts and gorgets
end

local function ValidateSets(sets)
	local validSets = gFunc.LoadFile('smart.lac/data/JOB.lua')
	if(validSets ~= nil) then
		return ContainsAllKeys(validSets, sets)
	end
	return false
end

local function AddModHeader(string)
	return chat.colors.LawnGreen..'[Smart.LAC] '..chat.colors.Reset..string
end

local function CheckForDefaults(sets)
	for k, v in pairs(sets) do
		if k ~= "general" and v.default == nil then
			if v.Default ~= nil then
				print(chat.warning(AddModHeader('Found key "Default" in table '..k..', did you mean "default"?')))
			else
				print(chat.warning(AddModHeader('Table '..k..' is missing a "default" set. All defined set tables should have a default.')))
			end
		end
	end
end


local function SucceedOrWarn(success, good, bad)
	return (success and chat.success(good) or chat.warning(bad))
end

local function SucceedOrError(success, good, bad)
	return (success and chat.success(good) or chat.error(bad))
end

---@param ability Action
local GetWeaponskillProperties = function(ability)
	return skills[3][ability.Id]
end

---@param sets sets
---@param key string
---@return boolean success?
local function GenericAbilityHandler(sets, key)
	local jobHandlers = gFunc.LoadFile('smart.lac/handlers/JOB/index.lua')
	local action = gData.GetAction()
	if sets[key] and sets[key]['customHandler'] ~= nil and type(sets[key]['customHandler']) == "function" then
		if sets[key]['customHandler'](sets) then return true end
	end

	local mainJob = gData.GetPlayer().MainJob
	if jobHandlers[mainJob] and jobHandlers[mainJob][key] then
		if jobHandlers[mainJob][key](action, sets) then return true end
	end
	local subJob = gData.GetPlayer().SubJob
	if jobHandlers[subJob] and jobHandlers[subJob][key] then
		if jobHandlers[subJob][key](action, sets) then return true end
	end
	-- Failure Case
	if not sets[key] then return false end

	if sets[key][action.Name] ~= nil then
		if sets[key].default ~= nil then
			EquipWithDefault(sets, key, sets[key][action.Name])
		else
			chat.warning(AddModHeader('default (base) set for key "'..key..'" was not found. Consider adding one.'))
			gFunc.EquipSet(sets[key][action.Name])
		end
		return true
	end
	if sets[key].default ~= nil then
		gFunc.EquipSet(sets[key].default)
		return true
	end
	-- Fail if all options failed.
	return false
end

local function CleanupSets(sets)
	local cleaned = {}
	local function __Cleanup(set)
		local retval = {}
		if type(set) ~= "table" then return set end
		for k, v in pairs(set) do
			if type(v) ~= "table" then
				retval[k] = (v=="Main" or v=="Sub") and nil or v
			end
			retval[k] = __Cleanup(v)
		end
		return retval
	end
	for k, v in pairs(sets) do
		if k == "Weapons" or k == "settings" then
			cleaned[k] = v
		end
		cleaned[k] = __Cleanup(v)
	end
end


---@type helpers
return {
	EnsureSugaredTable = EnsureSugaredTable,
	ContainsAllKeys = ContainsAllKeys,
	ValidatePlayerData = ValidatePlayerData,
	ValidateSets = ValidateSets,
	AddModHeader = AddModHeader,
	SucceedOrWarn = SucceedOrWarn,
	SucceedOrError = SucceedOrError,
	GetWeaponskillProperty = GetWeaponskillProperties,
	GenericAbilityHandler = GenericAbilityHandler,
	CleanupSets = CleanupSets,
	CheckForDefaults = CheckForDefaults
}