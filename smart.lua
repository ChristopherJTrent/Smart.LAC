--luacheck: globals gFunc gData gSettings gProfile chat T
---@type skills?
local skills = gFunc.LoadFile('smart.lac/data/skills.lua')
---@type playerData?
local validData = gFunc.LoadFile('smart.lac/data/index.lua')

---@type helpers?
local helpers = gFunc.LoadFile('smart.lac/helpers.lua')
if helpers == nil then 
	print("Smart.LAC [FATAL]: failed to load helpers.")
	return nil
end
helpers.CreateRequiredFiles()

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
	print (helpers)
	print("--------------------\naccessories table for validation")
	print (accessories)
	print("--------------------\nSpecialized Job handlers")
	print (jobHandlers)
	return nil
end


---@type modes?
---@diagnostic disable-next-line: lowercase-global
modes = gFunc.LoadFile('smart.lac/modes.lua')
assert(modes ~= nil, "[Fatal] Modes is unexpectedly nil.")

if not modes then return nil end
local load = function()
	local success = true
	helpers.PerformUpdateCheck()

	AugmentTypes = nil

	local sub = gData.GetPlayer().SubJob

	gSettings.AllowAddSet = true

	print(chat.colors.SpringGreen..'Welcome to Smart.LAC!'..chat.colors.Reset)

	data.ownedBelts = helpers.EnsureSugaredTable(data.ownedBelts)
	data.ownedGorgets = helpers.EnsureSugaredTable(data.ownedGorgets)

	if globals and globals.debug  then
		print(data.ownedBelts.contains ~= nil
				and chat.success("    Tables have been sugared")
				or chat.error("    Table sugaring failed."))
	end

	if not helpers.ValidatePlayerData(data) then
		print(helpers.AddModHeader(chat.warning('Failed to validate index.lua')))
		success = false
	end

	local sets = modes.getSets()

	local validator = gFunc.LoadFile('smart.lac/handlers/validations.lua')
	assert(validator ~= nil, "Validator unexpectedly nil.")
	validator(sets)

	if not helpers.ValidateSets(sets) then
		print(helpers.AddModHeader(chat.warning('Failed to validate sets')))
		success = false
	end

	if sets.general and sets.general.Idle  then
		gFunc.EquipSet(sets.general.Idle)
	else
		print(helpers.AddModHeader(helpers.SucceedOrWarn(false, "",
														"Failed to equip default idle set, please check your gear.")))
		success = false
	end

	gProfile.Sets = sets

	modes.initializeWindow()

	modes.registerKeybinds()

	print(helpers.AddModHeader(helpers.SucceedOrWarn(success, 'All validations passed', 'Some validations failed, check chat output for info.')))
end

local unload = function()
  modes.setWindowVisibility(false)
end
-- This is the only callback that natively accepts an argument
local command = function(args)
	local switch = {
		equip = function(args)
			local switch = {
				function(_) print("equip requires at least 2 arguments") end,
				function(_) print("equip requires at least 2 arguments") end,
				function(a)
					local sets = modes.getSets()
					gFunc.LockSet(sets[a[2]][a[3]], 15)
				end,
				function(a)
					local sets = modes.getSets()
					gFunc.LockSet(sets[a[2]][a[3]][a[4]], 15)
				end,
				function(a)
					local sets = modes.getSets()
					gFunc.LockSet(sets[a[2]][a[3]][a[4]][a[5]], 15)
				end,
				function(a)
					local sets = modes.getSets()
					gFunc.LockSet(sets[a[2]][a[3]][a[4]][a[5]][a[6]], 15)
				end
			}
			switch[#args](args)
		end,

		setMode = function(args)
			if #args ~= 2 then
				print(helpers.AddModHeader("setMode requires exactly 1 argument."))
			else
				modes.setActiveMode(args[2])
			end
		end,

		setWeaponGroup = function(args)
			if #args ~= 2 then
				print(helpers.AddModHeader(chat.error('setWeaponGroup requires exactly 1 argument')))
			else
				modes.setActiveMode(args[2])
			end
		end,

		setWindowLocation = function(args) 
			if #args ~= 3 then
				print(helpers.AddModHeader("setWindowLocation requires exactly 3 arguments"))
			elseif string.lower(args[2]) == 'x' then
				modes.setWindowPosX(tonumber(args[3]) or ModeTable.imgui.windowPosX)
			elseif string.lower(args[2]) == 'y' then
				modes.setWindowPosY(tonumber(args[3]) or ModeTable.imgui.windowPosY)
			else 
				print(helpers.AddModHeader("second argument must be either x or y"))
			end
		end,

		nextMode = function()
			modes.nextMode()
		end,

		nextWeaponGroup = function()
			modes.nextWeaponGroup()
		end,
		nextSecondaryGroup = function()
			modes.nextSecondaryGroup()
		end,
		nextOverride = function(args)
			if #args ~= 2 then 
				print(helpers.AddModHeader(chat.error('nextOverride requires a layer index')))
			else
				modes.nextOverrideState(args[2])
			end
		end,
		subjobPalette = function()
			local subjob = gData.GetPlayer().SubJob
			AshitaCore:GetChatManager():QueueCommand(-1, "/tc palette change \""..subjob.." JAs\"")
		end
	}
	switch[args[1]](args)
end

local default = function()
	-- return nil
	local player = gData.GetPlayer()
	local sets = modes.getSets()
	if ModeTable.weaponsEnabled then
		local currentWeaponSet = ModeTable.weaponGroups[ModeTable.weaponGroupList[ModeTable.currentWeaponGroup]]
		if currentWeaponSet.constraints and not T(currentWeaponSet.constraints):all(function(v) return v() end) then
			print(helpers.AddModHeader(chat.color1(92, "Weapon group constraint failed. Bumping weapon group...")))
			modes.nextWeaponGroup()
		end
	end
	if ModeTable.secondaryEnabled then
		local currentWeaponSet = ModeTable.secondaryGroups[ModeTable.secondaryGroupList[ModeTable.currentSecondaryGroup]]
		if currentWeaponSet.constraints and not T(currentWeaponSet.constraints):all(function(v) return v() end) then
			print(helpers.AddModHeader(chat.color1(92, 'Secondary group constraint failed. Bumping secondary group...')))
			modes.nextSecondaryGroup()
		end
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

		set = modes.applyOverrides(set, "general", status)

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
	return helpers.GenericAbilityHandler(sets, "ability")
end

local item = function()
	local sets = modes.getSets()
	return helpers.GenericAbilityHandler(sets, "item")
end

local precast = function()
	local sets = modes.getSets()
	return helpers.GenericAbilityHandler(sets, "precast")
end

local midcast = function()
	local sets = modes.getSets()
	return helpers.GenericAbilityHandler(sets, "midcast")
end

local preshot = function()
	local sets = modes.getSets()
	return helpers.GenericAbilityHandler(sets, "preshot")
end

local midshot = function()
	local sets = modes.getSets()
	return helpers.GenericAbilityHandler(sets, 'midshot')
end

local weaponskill = function()
	local sets = modes.getSets()
	helpers.GenericAbilityHandler(sets, 'weaponskill')
	if(sets.settings ~= nil and sets.settings.allowElementalAccessories == true) then
		---@type Action?
		local action = gData.GetAction()
		if action == nil then return nil end
		accessories.DoBeltAndGorget(helpers.GetWeaponskillProperty(action), data)
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