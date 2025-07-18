--luacheck: globals gFunc gData gSettings gProfile chat T
Smart_Version = "0.6.7"
---@type skills?
local skills = gFunc.LoadFile('smart.lac/data/skills.lua')
---@type playerData?
local validData = gFunc.LoadFile('smart.lac/data/index.lua')

---@type Helpers?
Helpers = gFunc.LoadFile('smart.lac/Helpers.lua')
if Helpers == nil then 
	print("Smart.LAC [FATAL]: failed to load Helpers.")
	return nil
end
Helpers.CreateRequiredFiles()

AugmentTypes = gFunc.LoadFile('smart.lac/AugmentTypes.lua')

---@type playerData?
local data = gFunc.LoadFile('index.lua')
---@type globals?
local globals = gFunc.LoadFile('globals.lua')
---@type accessories?
local accessories = gFunc.LoadFile('smart.lac/accessories.lua')
---@type jobHandlers?
local jobHandlers = gFunc.LoadFile('smart.lac/handlers/JOB/index.lua')
---@diagnostic disable-next-line: lowercase-global
if(skills==nil or data==nil or validData==nil or globals == nil or jobHandlers == nil or accessories == nil) then
	print ("Failed to load a file.")
	print("--------------------\nGlobals")
	print (globals)
	print("--------------------\nSkills")
	print (skills)
	print("--------------------\nindex.lua")
	print (data)
	print("--------------------\nindex.lua for validation")
	print (validData)
	print("--------------------\nhelper functions")
	print (Helpers)
	print("--------------------\naccessories table for validation")
	print (accessories)
	print("--------------------\nSpecialized Job handlers")
	print (jobHandlers)
	return nil
end

if Helpers.ProfileFileExists('common') then
	gFunc.LoadFile('common')
end

local SkillNames = {
	"H2H",
	"Dagger",
	"Sword",
	"Great Sword",
	"Axe",
	"Great Axe",
	"Scythe",
	"Polearm",
	"Katana",
	"Great Katana",
	"Club",
	"Staff",
}

---@type modes?
---@diagnostic disable-next-line: lowercase-global
modes = gFunc.LoadFile('smart.lac/modes.lua')
assert(modes ~= nil, "[Fatal] Modes is unexpectedly nil.")

if not modes then return nil end
local load = function()
	local success = true
	print(chat.colors.SpringGreen..'Welcome to Smart.LAC!'..chat.colors.Reset)
	
	if not globals.disableUpdateCheck then
		Helpers.PerformUpdateCheck()
	else
		print(Helpers.AddModHeader('Update check is disabled. Please check for updates periodically.'))
	end
	AugmentTypes = nil

	Subjob = gData.GetPlayer().SubJob

	gSettings.AllowAddSet = true


	data.ownedBelts = Helpers.EnsureSugaredTable(data.ownedBelts)
	data.ownedGorgets = Helpers.EnsureSugaredTable(data.ownedGorgets)

	if globals and globals.debug  then
		print(data.ownedBelts.contains ~= nil
				and chat.success("    Tables have been sugared")
				or chat.error("    Table sugaring failed."))
	end

	if not Helpers.ValidatePlayerData(data) then
		print(Helpers.AddModHeader(chat.warning('Failed to validate index.lua')))
		success = false
	end

	local sets = modes.getSets()

	local validator = gFunc.LoadFile('smart.lac/handlers/validations.lua')
	assert(validator ~= nil, "Validator unexpectedly nil.")
	validator(sets)

	if not Helpers.ValidateSets(sets) then
		print(Helpers.AddModHeader(chat.warning('Failed to validate sets')))
		success = false
	end

	if sets.general and sets.general.Idle  then
		gFunc.EquipSet(sets.general.Idle)
	else
		print(Helpers.AddModHeader(Helpers.SucceedOrWarn(false, "",
														"Failed to equip default idle set, please check your gear.")))
		success = false
	end

	gProfile.Sets = sets

	modes.initializeWindow()

	modes.registerKeybinds()

	modes.TriggerPrimaryBumpChecker(true)
	modes.TriggerSecondaryBumpChecker(true)

	print(Helpers.AddModHeader(Helpers.SucceedOrWarn(success, 'All validations passed', 'Some validations failed, check chat output for info.')))
end

local unload = function()
  modes.setWindowVisibility(false)
end
-- This is the only callback that natively accepts an argument
-- Lazy-loaded 
local command = gFunc.LoadFIle("handlers/command")

local default = function()
	local main = gData.GetPlayer().MainJob
	local sub = gData.GetPlayer().SubJob
	if main == nil or sub == nil or main == "NON" then
		return
	end
	if ModeTable.lastMainhandBumpAttempt ~= nil or ModeTable.lastOffhandBumpAttempt ~= nil then
		local current = os.time()
		if current - (ModeTable.lastMainhandBumpAttempt or 0) < 10 or current - (ModeTable.lastOffhandBumpAttempt or 0) < 10 then
			return
		end
	end
	
	-- return nil
	local player = gData.GetPlayer()
	local sets = modes.getSets()
	if Helpers.SubJobHasChanged() or (player.Status ~= nil and player.Status ~= "Zoning" and ModeTable.weaponsEnabled) then
		modes.TriggerPrimaryBumpChecker()
	end
	if Helpers.SubJobHasChanged() or (player.Status ~= nil and player.Status ~= "Zoning" and ModeTable.secondaryEnabled) then
		modes.TriggerSecondaryBumpChecker()
	end


	if(sets['general']) then
		---@type EntityStatus
		local status = player.Status
		if(not status) then return end
		
    	local set = {}

		if(sets.general[status] ~= nil) then
			set = gFunc.Combine(set, sets.general[status])
		end
		if ModeTable.weaponsEnabled then
			set = gFunc.Combine(set, modes.getWeaponGroup())
		end
		if ModeTable.secondaryEnabled then
			set = gFunc.Combine(set, modes.getSecondaryGroup())
		end
		
		set = modes.applyOverrides(set, "general", status)
		
		if jobHandlers[player.MainJob] ~= nil and jobHandlers[player.MainJob].default ~= nil then
			local mainJobOverride = jobHandlers[player.MainJob].default(sets, status)
			if mainJobOverride then
				set = gFunc.Combine(set, mainJobOverride)
			end
		end
		if jobHandlers[player.SubJob] ~= nil and jobHandlers[player.SubJob].default ~= nil then
			local subJobOverride = jobHandlers[player.SubJob].default(sets, status)
			if subJobOverride then
				set = gFunc.Combine(set, subJobOverride)
			end
		end


		if (sets.general.buffs) then
			for k, v in pairs(sets.general.buffs) do
				if gData.GetBuffCount(k) > 0 then
					set = gFunc.Combine(set, v)
					set = modes.applyOverrides(set, 'general', 'buffs', k)
				end
			end
		end
		gFunc.EquipSet(set)
	end
end

local ability = function()
	local sets = modes.getSets()
	return Helpers.GenericAbilityHandler(sets, "ability")
end

local item = function()
	local sets = modes.getSets()
	return Helpers.GenericAbilityHandler(sets, "item")
end

local precast = function()
	local sets = modes.getSets()
	return Helpers.GenericAbilityHandler(sets, "precast")
end

local midcast = function()
	local sets = modes.getSets()
	return Helpers.GenericAbilityHandler(sets, "midcast")
end

local preshot = function()
	local sets = modes.getSets()
	return Helpers.GenericAbilityHandler(sets, "preshot")
end

local midshot = function()
	local sets = modes.getSets()
	return Helpers.GenericAbilityHandler(sets, 'midshot')
end

local weaponskill = function()
	local sets = modes.getSets()
	Helpers.GenericAbilityHandler(sets, 'weaponskill')
	if(sets.settings ~= nil and sets.settings.allowElementalAccessories == true) then
		---@type Action?
		local action = gData.GetAction()
		if action == nil then return nil end
		accessories.DoBeltAndGorget(Helpers.GetWeaponskillProperty(action), data)
	end
end


return (function()
	---@return smartProfile
	local retFunc = function()

		---@class smartProfile
		local returnTable = T{
			Packer = modes.generatePackerConfig(),
			OnLoad    = load,
			OnUnload  = unload,
			HandleCommand = command,
			HandleDefault = default,
			HandleAbility = ability,
			HandleItem    = item,
			HandlePrecast = precast,
			HandleMidcast = midcast,
			HandlePreshot = preshot,
			HandleMidshot = midshot,
			HandleWeaponskill = weaponskill
		}

		function returnTable:withPacker(packerData)
			self.Packer = packerData
			return self
		end
		
		function returnTable:appendPacker(t)
			self.Packer[#self.Packer] = t
			return self
		end

		function returnTable:aAppendPacker(array)
			for _, v in ipairs(array) do
				self.Packer[#self.Packer + 1] = v
			end
			return self
		end

		return returnTable
	end

	local shared = gFunc.LoadFile('shared.lua')
	if shared ~= nil then
		if shared.overrides ~= nil then
			modes.enableOverrideLayers()
			for k, v in pairs(shared.overrides) do
				modes.registerOverride(k, v)
			end
		end
	end
	return (function()
		---@param sets sets
		return function(sets)
			if sets ~= nil then
				modes.registerSets('default', (shared ~= nil and shared.defaults ~= nil) and sets:merge(shared.defaults) or sets)
				modes.setActiveMode('default')
			end
			return retFunc()
		end
	end)()
end)()