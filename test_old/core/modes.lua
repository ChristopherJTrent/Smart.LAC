---@diagnostic disable: missing-parameter, missing-fields
local lu = require('luaunit')

TestModes = {
	---@type modes
	modes = {}
}

function TestModes:setUp()
	LOADFILE_REPLACE_CONTENT = T{}
	FORCE_LOAD_FAILURES = T{}
	self.modes = gFunc.LoadFile('modes.lua')
end

function TestModes:testExistence()
	lu.assertNotNil(self.modes)
end

function TestModes:testImguiDefaults()
	lu.assertEquals(ModeTable.imgui.windowPosX, 3200)
	lu.assertEquals(ModeTable.imgui.windowPosY, 750)

	LOADFILE_REPLACE_CONTENT['index.lua'] = {
		imgui = {
			posX = 100,
			posY = 100
		}
	}
	self.modes = gFunc.LoadFile('modes.lua')

	lu.assertEquals(ModeTable.imgui.windowPosX, 100)
	lu.assertEquals(ModeTable.imgui.windowPosY, 100)

	LOADFILE_REPLACE_CONTENT['index.lua'] = {
		imgui = {
			posY = 100
		}
	}

	self.modes = gFunc.LoadFile('modes.lua')

	lu.assertEquals(ModeTable.imgui.windowPosX, 3200)
	lu.assertEquals(ModeTable.imgui.windowPosY, 100)

	LOADFILE_REPLACE_CONTENT['index.lua'] = {
		imgui = {
			posX = 100
		}
	}
	self.modes = gFunc.LoadFile('modes.lua')

	lu.assertEquals(ModeTable.imgui.windowPosX, 100)
	lu.assertEquals(ModeTable.imgui.windowPosY, 750)
end

function TestModes:testEnableWeapongroups()
	lu.assertFalse(ModeTable.weaponsEnabled)

	self.modes.enableWeaponGroups()

	lu.assertTrue(ModeTable.weaponsEnabled)
end

function TestModes:testEnableSecondarygroups()
	lu.assertFalse(ModeTable.secondaryEnabled)

	self.modes.enableSecondaryGroups()

	lu.assertTrue(ModeTable.secondaryEnabled)
end

function TestModes:testEnableOverrideLayers()
	lu.assertFalse(ModeTable.overrideLayersEnabled)

	self.modes.enableOverrideLayers()

	lu.assertTrue(ModeTable.overrideLayersEnabled)
end

function TestModes:testRegisterSets()
	self.modes.registerSets("test", { general = { Idle = { Head = "Test" }}})

	lu.assertEquals(ModeTable.modes["test"], { general = { Idle = { Head = "Test"}}})
	lu.assertEquals(ModeTable.modeList[#ModeTable.modeList], "test")
end

function TestModes:testRegisterWeaponGroup()
	self.modes.registerWeaponGroup("Naegling", {general = { Engaged = { Main = "Naegling"}}})

	lu.assertEquals(ModeTable.weaponGroups['Naegling'], {general = { Engaged = { Main = "Naegling"}}})
	lu.assertEquals(ModeTable.weaponGroupList[#ModeTable.weaponGroupList], "Naegling")
end

function TestModes:testRegisterSecondaryGroup()
	self.modes.registerSecondaryGroup("Naegling", {general = { Engaged = { Main = "Naegling"}}})

	lu.assertEquals(ModeTable.secondaryGroups['Naegling'], {general = { Engaged = { Main = "Naegling"}}})
	lu.assertEquals(ModeTable.secondaryGroupList[#ModeTable.secondaryGroupList], "Naegling")
end

function TestModes:testRegisterOverride()
	self.modes.registerOverride('test', {Main = "test"})
	lu.assertEquals(ModeTable.overrideLayers[1][1], {})
	lu.assertEquals(ModeTable.overrideLayers[1][2], {Main = "test"})
	lu.assertEquals(ModeTable.overrideLayerNames[1], "test")
	lu.assertEquals(ModeTable.overrideStateNames[1][1], "OFF")
	lu.assertEquals(ModeTable.overrideStateNames[1][2], "ON")
	lu.assertEquals(ModeTable.overrideLayerStates[1], 1)
	lu.assertEquals(ModeTable.keybinds[1], "1")

	lu.assertNil(self.modes.registerOverride('test', {Main = "test"}))

	self.modes.registerOverride('test', {Main = "testy"}, "testy")

	lu.assertEquals(ModeTable.overrideLayers[1][3], {Main = "testy"})
	lu.assertEquals(ModeTable.overrideStateNames[1][3], "testy")

	self.modes.registerOverride('dt', {general = { Engaged = { Body = "Malignance Tabard"}}}, "hybrid", "f")

	lu.assertEquals(ModeTable.overrideLayers[2][1], {})
	lu.assertEquals(ModeTable.overrideLayers[2][2], {general = { Engaged = { Body = "Malignance Tabard"}}})
	lu.assertEquals(ModeTable.overrideLayerNames[2], "dt")
	lu.assertEquals(ModeTable.overrideStateNames[2][1], "OFF")
	lu.assertEquals(ModeTable.overrideStateNames[2][2], "hybrid")
	lu.assertEquals(ModeTable.overrideLayerStates[2], 1)
	lu.assertEquals(ModeTable.keybinds[2], "f")
end

function TestModes:testGeneratePackerConfig()
	self.modes.registerSets('test', {general = { Idle = { Body = "test chest"}}})

	lu.assertEquals(self.modes.generatePackerConfig(), {"test chest"})

	self.modes.registerWeaponGroup("Naegling", {general = { Idle = { Main = "Naegling"}}})
	lu.assertEquals(self.modes.generatePackerConfig(), {"test chest", "Naegling"})

	FORCE_LOAD_FAILURES[#FORCE_LOAD_FAILURES+1] = "smart.lac/packerBuilder.lua"
	lu.assertNil(self.modes.generatePackerConfig())
end

function TestModes:testRegisterKeybinds()
	---@type ExpectedChatCommands[]
	AshitaCore.ExpectedChatCommands = T{
		{mode = -1, command = "/unbind all"},
		{mode = -1, command = "/bind F12 /lac fwd nextMode"},
		{mode = -1, command = "/bind F11 /lac fwd nextWeaponGroup"},
		{mode = -1, command = "/bind F10 /lac fwd nextSecondaryGroup"},
	}
	self.modes.registerKeybinds()
	lu.assertEquals(AshitaCore.ExpectedChatCommands, {})

	---@type ExpectedChatCommands[]
	AshitaCore.ExpectedChatCommands = T{
		{mode = -1, command = "/unbind all"},
		{mode = -1, command = "/bind F12 /lac fwd nextMode"},
		{mode = -1, command = "/bind F11 /lac fwd nextWeaponGroup"},
		{mode = -1, command = "/bind F10 /lac fwd nextSecondaryGroup"},
		{mode = -1, command = "/bind 1 /lac fwd nextOverride 1"}
	}
	self.modes.registerOverride('test', {})
	self.modes.registerKeybinds()
	lu.assertEquals(AshitaCore.ExpectedChatCommands, {})

	---@type ExpectedChatCommands[]
	AshitaCore.ExpectedChatCommands = T{
		{mode = -1, command = "/unbind all"},
		{mode = -1, command = "/bind F12 /lac fwd nextMode"},
		{mode = -1, command = "/bind F11 /lac fwd nextWeaponGroup"},
		{mode = -1, command = "/bind F10 /lac fwd nextSecondaryGroup"},
		{mode = -1, command = "/bind 1 /lac fwd nextOverride 1"},
		{mode = -1, command = "/bind ^1 /lac fwd setActiveWeaponGroup 1"}
	}
	
	self.modes.registerWeaponGroup('Naegling', {Main = "Naegling"})
	self.modes.registerKeybinds()
	lu.assertEquals(AshitaCore.ExpectedChatCommands, {})

	---@type ExpectedChatCommands[]
	AshitaCore.ExpectedChatCommands = T{
		{mode = -1, command = "/unbind all"},
		{mode = -1, command = "/bind F12 /lac fwd nextMode"},
		{mode = -1, command = "/bind F11 /lac fwd nextWeaponGroup"},
		{mode = -1, command = "/bind F10 /lac fwd nextSecondaryGroup"},
		{mode = -1, command = "/bind 1 /lac fwd nextOverride 1"},
		{mode = -1, command = "/bind ^1 /lac fwd setActiveWeaponGroup 1"},
		{mode = -1, command = "/bind !1 /lac fwd setActiveSecondaryGroup 1"}
	}
	self.modes.registerSecondaryGroup('Ullr', { Range = "Ullr"})
	self.modes.registerKeybinds()
	lu.assertEquals(AshitaCore.ExpectedChatCommands, {})
end

function TestModes:testApplyOverrides()
	lu.assertEquals(self.modes.applyOverrides({Main = "test"}), {Main = "test"})
	
	self.sets = {
		general = {
			Engaged = {
				Head = "Nyame Helm",
				Body = "Nyame Mail",
				Hands = "Nyame Gauntlets",
				Legs = "Nyame Flanchard",
				Feet = "Nyame Sollerets"
			},
			buffs = {
				['Sublimation: Activated'] = {
					Body = "Pedagogy Gown +3"
				}
			}
		}
	}
	
	self.modes.enableOverrideLayers()
	
	self.modes.registerOverride("dual-wield", {
		general = {
			Engaged = {
				Head = "DW",
				Body = "DW",
				Hands = "DW",
				Legs = "DW"
			}
		}
	}, "high")
	self.modes.registerOverride("dual-wield", {
		general = {
			Engaged = {
				Head = "DW",
				Body = "DW",
				Hands = "DW"
			}
		}
	}, 'medium')
	self.modes.registerOverride("dual-wield", {
		general = {
			Engaged = {
				Head = "DW"
			}
		}
	}, 'low')

	self.modes.registerOverride('sublimation-refresh', {
		general = {
			buffs = {
				['Sublimation: Activated'] = {
					Body = "Arbatel Gown +3"
				}
			}
		}
	})

	lu.assertEquals(self.modes.applyOverrides(self.sets.general.Engaged, 'general', 'Engaged'), 
					self.sets.general.Engaged)
	
	self.modes.nextOverrideState('dual-wield')

	lu.assertEquals(self.modes.applyOverrides(self.sets.general.Engaged, 'general', 'Engaged'), {
		Head = "DW",
		Body = "DW",
		Hands = "DW",
		Legs = "DW",
		Feet = "Nyame Sollerets"
	})

	lu.assertEquals(self.modes.applyOverrides(self.sets.general.buffs['Sublimation: Activated'], 'general', 'buffs', 'Sublimation: Activated'), {
		Body = "Pedagogy Gown +3"
	})

	self.modes.nextOverrideState('sublimation-refresh')

	lu.assertEquals(self.modes.applyOverrides(self.sets.general.buffs['Sublimation: Activated'], 'general', 'buffs', 'Sublimation: Activated'), {
		Body = "Arbatel Gown +3"
	})
end

function TestModes:testNextOverrideState()
	self.modes.enableOverrideLayers()

	self.modes.registerOverride('test', {}, '1')
	self.modes.registerOverride('test', {}, '2')
	lu.assertEquals(ModeTable.overrideLayerStates[1], 1)

	self.modes.nextOverrideState('test')
	lu.assertEquals(ModeTable.overrideLayerStates[1], 2)

	self.modes.nextOverrideState(1)
	lu.assertEquals(ModeTable.overrideLayerStates[1], 3)

	self.modes.nextOverrideState('1')
	lu.assertEquals(ModeTable.overrideLayerStates[1], 1)
end

function TestModes:testSetActiveMode()
	self.modes.registerSets("test1", {"test1"})
	self.modes.registerSets("test2", {"test2"})

	self.modes.setActiveMode("2")
	lu.assertEquals(ModeTable.currentMode, 2)
	self.modes.setActiveMode("3")
	lu.assertEquals(ModeTable.currentMode, 2)

	self.modes.setActiveMode("test1")
	lu.assertEquals(ModeTable.currentMode, 1)
	lu.assertEquals(self.modes.getSets(), {'test1'})

	self.modes.setActiveMode('test3')
	lu.assertEquals(ModeTable.currentMode, 1)
end

function TestModes:testSetActiveWeaponGroup()
	lu.assertNil(self.modes.setActiveWeaponGroup("test"))
	self.modes.enableWeaponGroups()
	self.modes.registerWeaponGroup("naegling", {Main = "Naegling"})
	self.modes.registerWeaponGroup("almace", {Main = "Almace"})
	self.modes.registerWeaponGroup("tizona", {Main = "Tizona"})
	
	self.modes.setActiveWeaponGroup("2")
	lu.assertEquals(ModeTable.currentWeaponGroup, 2)
	lu.assertEquals(self.modes.getWeaponGroup(), {Main = "Almace"})

	self.modes.setActiveWeaponGroup("tizona")
	lu.assertEquals(ModeTable.currentWeaponGroup, 3)
	lu.assertEquals(self.modes.getWeaponGroup(), {Main = "Tizona"})

	self.modes.setActiveWeaponGroup("maxentius")
	lu.assertEquals(ModeTable.currentWeaponGroup, 3)
	lu.assertEquals(self.modes.getWeaponGroup(), {Main = "Tizona"})
end

function TestModes:testSetActiveSecondaryGroup()
	lu.assertNil(self.modes.setActiveSecondaryGroup("test"))
	self.modes.enableSecondaryGroups()
	self.modes.registerSecondaryGroup("Fomalhaut", {Range = "Fomalhaut"})
	self.modes.registerSecondaryGroup("Gastraphetes", {Range = "Gastraphetes"})
	self.modes.registerSecondaryGroup("Armageddon", {Range = "Armageddon"})

	self.modes.setActiveSecondaryGroup("2")
	lu.assertEquals(ModeTable.currentSecondaryGroup, 2)
	lu.assertEquals(self.modes.getSecondaryGroup(), {Range = "Gastraphetes"})

	self.modes.setActiveSecondaryGroup("Armageddon")
	lu.assertEquals(ModeTable.currentSecondaryGroup, 3)
	lu.assertEquals(self.modes.getSecondaryGroup(), {Range = "Armageddon"})

	self.modes.setActiveSecondaryGroup("Annihilator")
	lu.assertEquals(ModeTable.currentSecondaryGroup, 3)
	lu.assertEquals(self.modes.getSecondaryGroup(), {Range = "Armageddon"})
end

function TestModes:testNextMode()
	self.modes.registerSets("test1", {"tests"})
	self.modes.registerSets("test2", {"tests"})
	lu.assertEquals(ModeTable.currentMode, 1)
	self.modes.nextMode()
	lu.assertEquals(ModeTable.currentMode, 2)
	self.modes.nextMode()
	lu.assertEquals(ModeTable.currentMode, 1)
end

function TestModes:testNextWeaponGroup()
	self.modes.enableWeaponGroups()

	self.modes.registerWeaponGroup("Ukonvasara", {Main = "Ukonvasara"})
	self.modes.registerWeaponGroup("Chango", {Main = "Chango"})

	lu.assertEquals(ModeTable.currentWeaponGroup, 1)
	self.modes.nextWeaponGroup()
	lu.assertEquals(ModeTable.currentWeaponGroup, 2)
	self.modes.nextWeaponGroup()
	lu.assertEquals(ModeTable.currentWeaponGroup, 1)
end

function TestModes:testNextSecondaryGroup()
	self.modes.enableSecondaryGroups()
	
	self.modes.registerSecondaryGroup("Death Penalty", {Range = "Death Penalty"})
	self.modes.registerSecondaryGroup("Ataktos", {Range = "Ataktos"})

	lu.assertEquals(ModeTable.currentSecondaryGroup, 1)
	self.modes.nextSecondaryGroup()
	lu.assertEquals(ModeTable.currentSecondaryGroup, 2)
	self.modes.nextSecondaryGroup()
	lu.assertEquals(ModeTable.currentSecondaryGroup, 1)
end

function TestModes:testSetWindowPosX()
	lu.assertEquals(ModeTable.imgui.windowPosX, 3200)
	self.modes.setWindowPosX(100)
	lu.assertEquals(ModeTable.imgui.windowPosX, 100)
end

function TestModes:testSetWindowPosY()
	lu.assertEquals(ModeTable.imgui.windowPosY, 750)
	self.modes.setWindowPosY(100)
	lu.assertEquals(ModeTable.imgui.windowPosY, 100)
end

function TestModes:testSetWindowVisibility()
	lu.assertTrue(ModeTable.enableWindow)
	self.modes.setWindowVisibility(false)
	lu.assertFalse(ModeTable.enableWindow)
	self.modes.toggleWindowVisibility()
	lu.assertTrue(ModeTable.enableWindow)
end