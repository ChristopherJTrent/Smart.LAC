
local lu = require('luaunit')

local sets = {
	general = {
		idle = {

		}
	},
	weaponskill = {
		Default = {}
	}
}

TestSmart = {}

function TestSmart:setUp()
	self.smart = require('smart')
end

function TestSmart:tearDown()
	FORCE_LOAD_FAILURES = T{}
	LOADFILE_REPLACE_CONTENT = T{}
	EXPECTED_SET = nil
end

function TestSmart:testLoadFailures()
	FORCE_LOAD_FAILURES[1] = "smart.lac/helpers.lua"
	lu.assertNil(gFunc.LoadFile('smart.lac/smart.lua'))
	FORCE_LOAD_FAILURES[1] = "index.lua"
	lu.assertNil(gFunc.LoadFile('smart.lac/smart.lua'))
end

function TestSmart:testLoad()

	--[[
		WARNING: Do not use the code in this test as a model for anything you should be doing.
		The code here is doing things that should not be done.
		It is doing these non-standards compliant things to test edge-case handling.
		DO NOT USE THIS CODE.
	]]
	print('testing minimum profile')
	local smartProfile = self.smart(sets)
	AshitaCore.ExpectedChatCommands = {
		{mode = -1, command = '/unbind all'},
		{mode = -1, command = "/bind F12 /lac fwd nextMode"},
		{mode = -1, command = "/bind F11 /lac fwd nextWeaponGroup"},
		{mode = -1, command = "/bind F10 /lac fwd nextSecondaryGroup"}
	}
	smartProfile.OnLoad()

	print('testing validation failure')
	FORCE_LOAD_FAILURES[1] = 'globals.lua'
	AshitaCore.ExpectedChatCommands = {
		{mode = -1, command = '/unbind all'},
		{mode = -1, command = "/bind F12 /lac fwd nextMode"},
		{mode = -1, command = "/bind F11 /lac fwd nextWeaponGroup"},
		{mode = -1, command = "/bind F10 /lac fwd nextSecondaryGroup"}
	}
	smartProfile.OnLoad()

	FORCE_LOAD_FAILURES[1] = nil

	print('testing Idle equip')

	AshitaCore.ExpectedChatCommands = {
		{mode = -1, command = '/unbind all'},
		{mode = -1, command = "/bind F12 /lac fwd nextMode"},
		{mode = -1, command = "/bind F11 /lac fwd nextWeaponGroup"},
		{mode = -1, command = "/bind F10 /lac fwd nextSecondaryGroup"}
	}

	smartProfile = self.smart({
		general = {
			Idle = {
				Head = "test"
			}
		}
	})

	EXPECTED_SET = {Head = "test"}

	smartProfile.OnLoad()

	print('finish testing load')
end
function TestSmart:testUnload()
	lu.assertTrue(ModeTable.enableWindow)
	local smartProfile = self.smart({})
	smartProfile.OnUnload()
	lu.assertFalse(ModeTable.enableWindow)
end

function TestSmart:testInvalidCommand()
	local smartProfile = self.smart({})
	smartProfile.HandleCommand({'foo'})
end

function TestSmart:testCommandEquip()
	local sets = {
		general = {
			Idle = {
				Head = "Test"
			}
		},
		lockstyle = {
			a = {
				default = {
					Head = "TestA"
				},
				b = {
					default = T{
						Head = "TestB"
					},
					c = {
						default = T{
							Head = "TestC"
						}
					}
				}
			},
		}
	}
	local smartProfile = self.smart(sets)

	EXPECTED_SET = {Head = "Test"}

	smartProfile.HandleCommand({"equip", "general", "Idle"})

	EXPECTED_SET = {Head = "TestA"}
	smartProfile.HandleCommand({"equip", "lockstyle", "a", "default"})

	EXPECTED_SET = {Head = "TestB"}
	smartProfile.HandleCommand({"equip", "lockstyle", "a", "b", "default"})

	EXPECTED_SET = {Head = "TestC"}
	smartProfile.HandleCommand({"equip", "lockstyle", "a", "b", "c", "default"})
end

function TestSmart:testCommandSetMode()
	local sets = {
		general = {
			Idle = {
				Head = "TestA"
			}
		}
	}
	local smartProfile = self.smart(sets)

	modes.registerSets("test", {
		general = {
			Idle = {
				Head = "TestB"
			}
		}
	})

	smartProfile.HandleCommand({"setMode"})
	lu.assertEquals(ModeTable.currentMode, 1)

	smartProfile.HandleCommand({"setMode", "test"})
	lu.assertEquals(ModeTable.currentMode, 2)

	smartProfile.HandleCommand({"setMode", "default"})
	lu.assertEquals(ModeTable.currentMode, 1)
end

function TestSmart:testCommandSetWeaponGroup()
	local sets = {}
	local smartProfile = self.smart(sets)

	modes.enableWeaponGroups()
	modes.registerWeaponGroup("Naegling", {Main = "Naegling"})
	modes.registerWeaponGroup("Shining One", {Main = "Shining One"})

	smartProfile.HandleCommand({"setWeaponGroup"})
	lu.assertEquals(ModeTable.currentWeaponGroup, 1)

	smartProfile.HandleCommand({"setWeaponGroup", "Shining One"})
	lu.assertEquals(ModeTable.currentWeaponGroup, 2)

	smartProfile.HandleCommand({"setWeaponGroup", "Naegling"})
	lu.assertEquals(ModeTable.currentWeaponGroup, 1)
end

function TestSmart:testCommandSetSecondaryGroup()
	local smartProfile = self.smart({})
	modes.enableSecondaryGroups()
	modes.registerSecondaryGroup("Fomalhaut", {Range = "Fomalhaut"})
	modes.registerSecondaryGroup("Armageddon", {Range = "Armageddon"})
	
	smartProfile.HandleCommand({"setSecondaryGroup"})
	lu.assertEquals(ModeTable.currentSecondaryGroup, 1)
	smartProfile.HandleCommand({"setSecondaryGroup", "Armageddon"})
	lu.assertEquals(ModeTable.currentSecondaryGroup, 2)
	smartProfile.HandleCommand({"setSecondaryGroup", "Fomalhaut"})
	lu.assertEquals(ModeTable.currentSecondaryGroup, 1)
end

function TestSmart:testCommandSetWindowLocation()
	local smartProfile = self.smart({})
	local startingX = ModeTable.imgui.windowPosX
	local startingY	= ModeTable.imgui.windowPosY
	
	smartProfile.HandleCommand({'setWindowLocation'})
	lu.assertEquals(ModeTable.imgui.windowPosX, startingX)
	lu.assertEquals(ModeTable.imgui.windowPosY, startingY)

	smartProfile.HandleCommand({'setWindowLocation', 'x'})
	lu.assertEquals(ModeTable.imgui.windowPosX, startingX)
	lu.assertEquals(ModeTable.imgui.windowPosY, startingY)

	smartProfile.HandleCommand({'setWindowLocation', 'foo', 'bar'})
	lu.assertEquals(ModeTable.imgui.windowPosX, startingX)
	lu.assertEquals(ModeTable.imgui.windowPosY, startingY)

	smartProfile.HandleCommand({'setWindowLocation', 'x', '100'})
	lu.assertEquals(ModeTable.imgui.windowPosX, 100)
	lu.assertEquals(ModeTable.imgui.windowPosY, startingY)

	smartProfile.HandleCommand({'setWindowLocation', 'y', '100'})
	lu.assertEquals(ModeTable.imgui.windowPosX, 100)
	lu.assertEquals(ModeTable.imgui.windowPosY, 100)

	smartProfile.HandleCommand({'setWindowLocation', 'y', 'F'})
	lu.assertEquals(ModeTable.imgui.windowPosX, 100)
	lu.assertEquals(ModeTable.imgui.windowPosY, 100)
end

function TestSmart:testCommandNextMode()
	local smartProfile = self.smart({general = {Idle = {Head = "TestA"}}})
	modes.registerSets('test', {general = {Idle = {Head = "TestB"}}})

	smartProfile.HandleCommand({'nextMode'})
	lu.assertEquals(ModeTable.currentMode, 2)
end

function TestSmart:testCommandNextWeaponGroup()
	local smartProfile = self.smart({})

	modes.enableWeaponGroups()
	modes.registerWeaponGroup("Naegling", {Main = "Naegling"})
	modes.registerWeaponGroup("Shining One", {Main = "Shining One"})

	smartProfile.HandleCommand({'nextWeaponGroup'})
	lu.assertEquals(ModeTable.currentWeaponGroup, 2)
end

function TestSmart:testCommandNextSecondaryGroup()
	local smartProfile = self.smart({})

	modes.enableSecondaryGroups()
	modes.registerSecondaryGroup('Fomalhaut', {Range = 'Fomalhaut'})
	modes.registerSecondaryGroup('Armageddon', {Range = 'Armageddon'})

	smartProfile.HandleCommand({'nextSecondaryGroup'})
	lu.assertEquals(ModeTable.currentSecondaryGroup, 2)
end

function TestSmart:testCommandNextOverride()
	
end