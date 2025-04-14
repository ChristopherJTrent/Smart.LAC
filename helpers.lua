local skills = gFunc.LoadFile('smart.lac/data/skills.lua')
local jobHandlers = gFunc.LoadFile('smart.lac/handlers/JOB/index.lua')

assert(skills ~= nil, "Skills file unexpectedly nil.")
assert(jobHandlers ~= nil, "Job handlers unexpectedly nil.")

local function EnsureSugaredTable(t)
	if t == nil then return t end
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

local function getSpellBaseName(spell)
	local start, _ = string.find(spell, ' ')
	local colon = string.find(spell, ':')
	if colon ~= nil then
		start = colon
	end
	if start == nil then return spell end
	local name = string.sub(spell, 1, start-1)
	return name
end

local function ValidatePlayerData(t)
	---@type playerData?
	local validData = gFunc.LoadFile('smart.lac/data/index.lua')
	assert(validData ~= nil, 'ValidData unexpectedly nil')
	---@type globals?
	local globals = gFunc.LoadFile('globals.lua')
	assert(globals ~= nil, "character globals unexpectedly nil.")
	local belts = ContainsAllKeys(validData.ownedBelts, t.ownedBelts)
	local gorgets = ContainsAllKeys(validData.ownedGorgets, t.ownedGorgets)
	if(globals.debug) then
		print("Belts: "..(belts and "true" or "false"))
		print("Gorgets: "..(gorgets and "true" or "false"))
	end
	return belts and gorgets
end

local function customFlattenTable(table) 
	local ignore = T{"Augment", "AugPath", "AugRank", "AugTrial", "Quantity", "Bag"}
	local ret = {}
	for k, v in pairs(table) do
		if (type(v) == type({}) and not ignore:contains(k)) then
			 local flat = customFlattenTable(v)
			 T(flat):each(function(vv) ret[#ret+1] = vv; end)
		elseif (not ignore:contains(k)) then
			ret[#ret + 1] = v
		end
	end
	return T(ret)
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
	if not sets[key] then return false end
	local action = gData.GetAction()
	if not jobHandlers or not action then return false end

	if sets[key] and sets[key]['customHandler'] ~= nil and type(sets[key]['customHandler']) == "function" then
		if sets[key]['customHandler'](sets) then return true end
	end

	local finalSet = sets[key].default ~= nil and sets[key].default or {}
	finalSet = modes.applyOverrides(finalSet, key, 'default')
	finalSet = sets[key][action.Type] and gFunc.Combine(finalSet, sets[key][action.Type]) or finalSet
	finalSet = sets[key][action.Skill] and gFunc.Combine(finalSet, sets[key][action.Skill]) or finalSet
	
	local mainJob = gData.GetPlayer().MainJob
	if jobHandlers[mainJob] and jobHandlers[mainJob][key] then
		local result = jobHandlers[mainJob][key](action, sets)
		finalSet = result and gFunc.Combine(finalSet, result) or finalSet
	end
	local subJob = gData.GetPlayer().SubJob
	if jobHandlers[subJob] and jobHandlers[subJob][key] then
		local result = jobHandlers[subJob][key](action, sets)
		finalSet = result and gFunc.Combine(finalSet, result) or finalSet
	end
	
	local base = getSpellBaseName(action.Name)
	finalSet = sets[key][base] and gFunc.Combine(finalSet, sets[key][base]) or finalSet
	finalSet = sets[key][action.Name] and gFunc.Combine(finalSet, sets[key][action.Name]) or finalSet
	finalSet = modes.applyOverrides(finalSet, key, action.Type)
	finalSet = modes.applyOverrides(finalSet, key, action.Skill)
	finalSet = modes.applyOverrides(finalSet, key, base)
	finalSet = modes.applyOverrides(finalSet, key, action.Name)
	if sets[key].buffs ~= nil then
		for k, v in pairs(sets[key].buffs) do
			if gData.GetBuffCount(k) > 0 then
				finalSet = gFunc.Combine(finalSet, v)
				finalSet = modes.applyOverrides(finalSet, key, 'buffs', k)
			end
		end
	end

	gFunc.EquipSet(finalSet)
	return true
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

local fileExists = function(filepath)
	local f = io.open(filepath, "r")
	if f ~= nil then
		f:close()
		return true
	else return false end
end

local CreateRequiredFiles = function()
	local s = require('settings')
	-- Diag: string:fmt is provided by ashita outside the normal filetree used for development.
	---@diagnostic disable-next-line: undefined-field
	local characterRoot = ("%sconfig\\addons\\luashitacast\\%s_%s"):fmt(AshitaCore:GetInstallPath(), s.name, s.server_id)
	local indexPath = characterRoot.."\\index.lua"
	if not fileExists(indexPath) then
		print("creating index")
		local index = io.open(indexPath, 'w+')
		assert(index ~= nil, "Index file unexpectedly nil")
		index:write('return {\n\townedBelts = T{\n\n\t},\n\townedGorgets=T{\n\n\t},\n\timgui = T{\n\t\tposX=0,\n\t\tposY=0\n\t}\n}\n')
		index:close()
	end
	local globalsPath = characterRoot.."\\globals.lua"
	if not fileExists(globalsPath) then
		print('creating globals')
		local globe = io.open(globalsPath, "w+")
		assert(globe ~= nil, "Globals file unexpectedly nil")
		globe:write([[return {
			debug = false,
			//set this to true if you experience crashes on load
			disableUpdateCheck = false
		}]])
		globe:close()
	end
	local sharedPath = characterRoot..'\\shared.lua'
	if not fileExists(sharedPath) then
		print('creating shared.lua')
		local shared = io.open(sharedPath, 'w+')
		assert(shared ~= nil, 'Shared file unexpectedly nil')
		shared:write('return {}')
		shared:close()
	end
end

local miniSemver = function(string)
	local function split(s,delimiter)
		delimiter = delimiter or '%s'
		local t={}
		local i=1
		for str in string.gmatch(s, '([^'..delimiter..']+)') do
			t[i] = str
			i = i + 1
		end
		return t
	end
	local fields = split(string, '.')
	local ret = {major = tonumber(fields[1]), minor = tonumber(fields[2]), patch = tonumber(fields[3])}
	if ret.major == nil or ret.minor == nil or ret.patch == nil then
		print('invalid semver string "'..string..'"')
		return nil
	end
	return ret
end

local performUpdateCheck = function()
	local largestUpdate = ''
	local beta = false
	local http = require('socket\\ssl\\https')
	http.TIMEOUT = 1
	local body, statusCode, _, _= http.request('https://raw.githubusercontent.com/ChristopherJTrent/Smart.LAC/refs/heads/master/version')
	if statusCode ~= 200 then
		print('Failed to download version info. Please check the github for updates')
	else
		-- ---@diagnostic disable-next-line: undefined-field
		-- local locVerPath = ("%sconfig\\addons\\luashitacast\\Smart.LAC\\version"):fmt(AshitaCore:GetInstallPath())
		-- local f = io.open(locVerPath, 'r+')
		-- if f ~= nil then
		local webVersion = miniSemver(body)
		local localVersion = miniSemver(Smart_Version)
		-- local localVersion = miniSemver(f:read("a"))
		-- f:close()
		if webVersion == nil or localVersion == nil then
			print(AddModHeader('version check failed. Please check the github for updates.'))
		else
			largestUpdate = localVersion.patch < webVersion.patch and 'patch' or largestUpdate
			largestUpdate = localVersion.minor < webVersion.minor and 'minor update' or largestUpdate
			largestUpdate = localVersion.major < webVersion.major and 'major update' or largestUpdate
			if localVersion.patch > webVersion.patch or localVersion.minor > webVersion.minor or localVersion.major > webVersion.major then
				beta = true
			end
		end
		-- else 
		-- 	print(AddModHeader('version check failed. Please check the github for updates.'))
		-- 	return
		-- end
	end
	if largestUpdate ~= '' then
		print(AddModHeader('New '..largestUpdate.." available, please update Smart.LAC at your earliest convenience."))
	elseif beta then
		print(AddModHeader(chat.colors.LightGoldenRodYellow.."Warning: You are running a yet-unreleased version of the framework. Support will not be provided."..chat.colors.Reset))
	else
		print(AddModHeader(chat.colors.SpringGreen..'Update Check Successful, current version: '..chat.colors.Reset..body))
	end
end

---@type helpers
return {
	slotNames = T{
		"Main",
		"Sub",
		"Range",
		"Ammo",
		"Head",
		"Neck",
		"Ear1",
		"Ear2",
		"Body",
		"Hands",
		"Ring1",
		"Ring2",
		"Back",
		"Waist",
		"Legs",
		"Feet"
	},
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
	customFlattenTable = customFlattenTable,
	CreateRequiredFiles = CreateRequiredFiles,
	PerformUpdateCheck = performUpdateCheck
}