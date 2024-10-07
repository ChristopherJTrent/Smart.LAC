--luacheck: globals gFunc gData gSettings gProfile chat T
---@type globals?
local globals = gFunc.LoadFile('globals.lua')
---@type skills?
local skills = gFunc.LoadFile('smart.lac/data/skills.lua')
---@type playerData?
local data = gFunc.LoadFile('index.lua')
---@type playerData?
local validData = gFunc.LoadFile('smart.lac/data/index.lua')
---@type helpers?
local helpers = gFunc.LoadFile('smart.lac/helpers.lua')
---@type accessories
local accessories = gFunc.LoadFile('smart.lac/accessories.lua')
---@type jobHandlers
local jobHandlers = gFunc.LoadFile('smart.lac/handlers/JOB/index.lua')
local modes = gFunc.LoadFile('smart.lac/modes.lua')
if not modes then return nil end
if(skills==nil or data==nil or validData==nil or globals == nil or helpers == nil or jobHandlers == nil) then
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

local load = function()
	local success = true

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

	AshitaCore:GetChatManager():QueueCommand(-1, '/bind silent F12 /lac fwd nextMode')
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind silent F11 /lac fwd nextWeaponGroup')
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind silent +F12 /lac fwd setMode '..modeTable.modeList[1])
	AshitaCore:GetChatManager():QueueCommand(-1, '/bind silent +F11 /lac fwd setWeaponGroup '..modeTable.weaponGroupList[1])
	
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
				modes.setWindowPosX(tonumber(args[3]))
			elseif string.lower(args[2]) == 'y' then
				modes.setWindowPosY(tonumber(args[3]))
			else 
				print(helpers.AddModHeader("second argument must be either x or y"))
			end
		end,

		nextMode = function()
			modes.nextMode()
		end,

		nextWeaponGroup = function()
			modes.nextWeaponGroup()
		end
	}
	switch[args[1]](args)
end

local default = function()
	local player = gData.GetPlayer()
	local sets = modes.getSets()

	if modeTable.weaponsEnabled then
		gFunc.EquipSet(modes.getWeaponGroup())
	end

	if(sets['general']) then
		local status = player.Status
		if(not status) then return end

    	local set = {}

		if(sets.general[status] ~= nil) then
			set = gFunc.Combine(set, sets.general[status])
		end

		if (sets.general.buffs) then
			for k, v in pairs(sets.general.buffs) do
				if gData.GetBuffCount(k) > 0 then
					set = gFunc.Combine(set, v)
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

---@param sets sets
local weaponskill = function()
	local sets = modes.getSets()
	helpers.GenericAbilityHandler(sets, 'weaponskill')
	if(sets.settings ~= nil and sets.settings.allowElementalAccessories == true) then
		accessories.DoBeltAndGorget(helpers.GetWeaponskillProperty(gData.GetAction()), data)
	end
end



---@param sets sets
---@return smartProfile
return function(sets)
	if sets ~= nil then
		modes.registerSets('default', sets)
		modes.setActiveMode('default')
		modes.setWindowVisibility(false)
	end

	---@type smartProfile
	local returnTable = T{
		Packer = modes.getSets(),
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

	return returnTable
end