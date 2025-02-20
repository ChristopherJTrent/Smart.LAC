
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
	FORCE_LOAD_FAILURES = T{}
	LOADFILE_REPLACE_CONTENT = T{}
	self.smart = require('smart')
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

	smartProfile.OnLoad()

	print('finish testing load')
end