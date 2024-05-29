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

local load = function(sets)
	local success = true
	local sub = gData.GetPlayer().SubJob
	gSettings.AllowAddSet = true
	print(chat.colors.SpringGreen..'Welcome to Smart.LAC!'..chat.colors.Reset)
	--print(helpers.AddModHeader('Validating data...'))
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
	if sets.Weapons and sets.Weapons[sub] then
		print(helpers.AddModHeader("Equipping weapons for subjob."))
		print(sets.Weapons[sub].Main)
		print(sets.Weapons[sub].Sub)
		gFunc.ForceEquipSet(sets.Weapons[sub])
	end
	if sets.settings == nil then
		print(helpers.AddModHeader("settings table not found."))
		if not data.DisableWeaponWarning then
			print(helpers.AddModHeader("Note: Mainhand and Offhand weapon slots are disabled by default when using Smart.LAC. \n"
			.."Set sets.settings.enableWeapons=true in your sets table to override this behavior. \n"
			.."Set DisableWeaponWarning = true in your profile's index.lua to disable this warning."))
		end
	end
	if sets.settings == nil or sets.settings.enableWeapons ~= true then
		print(helpers.AddModHeader('cleaned up sets'))
		gProfile.Sets = helpers.CleanupSets(sets)
		gFunc.Disable("Main")
		gFunc.Disable("Sub")
	end
	gProfile['SubjobOnLoad'] = sub
	gProfile.Sets = sets
	print(helpers.AddModHeader(helpers.SucceedOrWarn(success, 'All validations passed', 'Some validations failed, check chat output for info.')))
end

local unload = function() end
-- This is the only callback that natively accepts an argument
local command = function(args)
	local switch = {
		equip = function(args)
			local switch = {
				function(_) print("equip requires at least 2 arguments") end,
				function(_) print("equip requires at least 2 arguments") end,
				function(a) gFunc.LockSet(gProfile.Sets[a[2]][a[3]], 15) end,
				function(a) gFunc.LockSet(gProfile.Sets[a[2]][a[3]][a[4]], 15) end,
				function(a) gFunc.LockSet(gProfile.Sets[a[2]][a[3]][a[4]][a[5]], 15) end,
				function(a) gFunc.LockSet(gProfile.Sets[a[2]][a[3]][a[4]][a[5]][a[6]], 15) end
			}
			switch[#args](args)
		end
	}
	switch[args[1]](args)
end

local default = function(sets)
	local player = gData.GetPlayer()
	if player.SubJob ~= "NON" and gProfile.SubjobOnLoad ~= "NON" and player.SubJob ~= gProfile.SubjobOnLoad then
		print(helpers.AddModHeader("Subjob doesn't match what it was when your profile was loaded. Rerunning subjob checks. "
									.. 'Was: '
									..gProfile.SubjobOnLoad
									.." Now: "
									..player.SubJob))
		if sets.Weapons and sets.Weapons[player.SubJob] then
			print(helpers.AddModHeader("Subjob Weapon definitions found for new subjob, equipping..."))
			gFunc.EquipSet(sets.Weapons[player.SubJob])
		end
		gProfile.SubjobOnLoad = player.SubJob
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
local ability = function(sets)
	return helpers.GenericAbilityHandler(sets, "ability")
end
local item = function(sets)
	return helpers.GenericAbilityHandler(sets, "item")
end

local precast = function(sets)
	return helpers.GenericAbilityHandler(sets, "precast")
end

local midcast = function(sets)
	return helpers.GenericAbilityHandler(sets, "midcast")
end

local preshot = function(sets)
	return helpers.GenericAbilityHandler(sets, "preshot")
end

local midshot = function(sets)
	return helpers.GenericAbilityHandler(sets, 'midshot')
end

---@param sets sets
local weaponskill = function(sets)
	helpers.GenericAbilityHandler(sets, 'weaponskill')
	if(sets.settings ~= nil and sets.settings.allowElementalAccessories == true) then
		accessories.DoBeltAndGorget(helpers.GetWeaponskillProperty(gData.GetAction()), data)
	end
end



---@param sets sets
---@return smartProfile
return function(sets)
		---@nodiscard
		---@param f fun(sets:sets)
		local function curryWithSets(f)
			return function()
				f(sets)
			end
		end
		---@type smartProfile
		local returnTable = T{
			Sets = sets,
			Packer = sets,
			OnLoad    = curryWithSets(load),
			OnUnload  = unload,
			HandleCommand = command,
			HandleDefault = curryWithSets(default),
			HandleAbility = curryWithSets(ability),
			HandleItem    = curryWithSets(item),
			HandlePrecast = curryWithSets(precast),
			HandleMidcast = curryWithSets(midcast),
			HandlePreshot = curryWithSets(preshot),
			HandleMidshot = curryWithSets(midshot),
			HandleWeaponskill = curryWithSets(weaponskill)
		}

		function returnTable:withPacker(packerData)
			self.Packer = packerData
			return self
		end

		return returnTable
end