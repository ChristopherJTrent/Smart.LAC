---@diagnostic disable: missing-fields
---@type helpers
local helpers = require('helpers')
local lu = require('luaunit')

TestHelpers = {}

function TestHelpers:setUp()
	self.sets = T{
		ability = T{
			default = {
				Head = "Test"
			},
			['Corsair Roll'] = T{
				Body = "Test"
			},
			quickDraw = T{
				Hands = "Test"
			}
		},
		precast = T{
			default = T{
				Head = "Test"
			},
			utsusemi = T{
				Body = "Test"
			}
		},
		midcast = T{
			default = T{
				Head = "Test",
			},
			['Enhancing Magic'] = T{
				Body = "Test"
			},
			Cure = T{
				Hands = "Test"
			},
			['Fire III'] = {
				Legs = "Test"
			}
		},
		weaponskill = T{
			default = T{
				Head = "Test"
			},
			buffs = T{
				Warcry = T{
					Body = "Test"
				}
			}
		}
	}
end
function TestHelpers:tearDown()
	PLAYER_MAINJOB = nil
	PLAYER_SUBJOB = nil
	PLAYER_STATUS = nil
	ACTION_TYPE = nil
	ACTION_SKILL = nil
	ACTION_NAME = nil
	ACTION_ACTIONTYPE = nil
	ACTION_ID = nil
	EXPECTED_SET = nil
end

function TestHelpers:testEnsureSugaredTable()
	lu.assertNotNil(helpers.EnsureSugaredTable)
	lu.assertNil(helpers.EnsureSugaredTable(nil))
	lu.assertNotNil(helpers.EnsureSugaredTable({}).contains)
end

function TestHelpers:testContainsAllKeys()
	lu.assertNotNil(helpers.ContainsAllKeys)
	lu.assertTrue(helpers.ContainsAllKeys({a = 1}, {a = 2}))
	lu.assertFalse(helpers.ContainsAllKeys({a = 1}, {b = 2}))
	lu.assertTrue(helpers.ContainsAllKeys({a = 1}, {a = 1, b = 2}))
	lu.assertFalse(helpers.ContainsAllKeys({a = 1, b = 2}, {a = 1}))
end

function TestHelpers:testValidatePlayerData()
	lu.assertNotNil(helpers.ValidatePlayerData)
	lu.assertTrue(helpers.ValidatePlayerData({ownedBelts = {['Fotia Belt'] = true}, ownedGorgets = {['Fotia Gorget'] = true}, DisableWeaponWarning = false}))
end

function TestHelpers:testCustomFlattenTable()
	lu.assertNotNil(helpers.customFlattenTable)
	lu.assertEquals(helpers.customFlattenTable({}), {})
	lu.assertEquals(helpers.customFlattenTable({Head = "test"}), { "test" })
	lu.assertEquals(helpers.customFlattenTable({
		midcast = {
			Head = "test"
		}
	}), { "test" })
	lu.assertEquals(helpers.customFlattenTable({
		midcast = {
			Head = {
				Name = "test",
				Augment = "missing"
			}
		}
	}), { "test" })
end

function TestHelpers:testValidateSets()
	lu.assertNotNil(helpers.ValidateSets)
	lu.assertFalse(helpers.ValidateSets({}))
	lu.assertTrue(helpers.ValidateSets({
		weaponskill = T{
			default = T{}
		},
		general = T{
			Idle = T{},
			Engaged = T{}
		},
		ability = T{
			default = T{}
		},
		item = T{
			default = T{}
		},
		settings = T{}
	}))
end

function TestHelpers:testAddModHeader()
	lu.assertNotNil(helpers.AddModHeader)
	lu.assertEquals(helpers.AddModHeader(""), "[LG][Smart.LAC] [RS]")
	lu.assertEquals(helpers.AddModHeader("test"), "[LG][Smart.LAC] [RS]test")
end

function TestHelpers:testSucceedOrWarn()
	lu.assertNotNil(helpers.SucceedOrWarn)
	lu.assertEquals(helpers.SucceedOrWarn(true, "test", "fail"), "successtest")
	lu.assertEquals(helpers.SucceedOrWarn(false, "test", "fail"), "warningfail")
end

function TestHelpers:testSucceedOrError()
	lu.assertNotNil(helpers.SucceedOrError)
	lu.assertEquals(helpers.SucceedOrError(true, "test", "fail"), "successtest")
	lu.assertEquals(helpers.SucceedOrError(false, "test", "fail"), "errorfail")
end

function TestHelpers:testGetWeaponskillProperties()
	lu.assertNotNil(helpers.GetWeaponskillProperty)
	lu.assertEquals(helpers.GetWeaponskillProperty({Id = 1}), {en="Combo", skillchain= {'Impaction'}})
end

function TestHelpers:testCustomHandlers()
	EXPECTED_SET = {Head = "test"}

	helpers.GenericAbilityHandler({
		weaponskill = T{
			customHandler = function()
				gFunc.EquipSet({Head = 'test'})
				return true
			end
		}
	}, 'weaponskill')
end

function TestHelpers:testActionType()
	EXPECTED_SET = { Head = "Test", Body = "Test" }
	ACTION_TYPE = "Corsair Roll"
	ACTION_NAME = "Chaos Roll"
	ACTION_ID = 1

	helpers.GenericAbilityHandler(self.sets, "ability")
end

function TestHelpers:testActionSkill()
	EXPECTED_SET = { Head = "Test", Body = "Test"}
	ACTION_TYPE = "White Magic"
	ACTION_SKILL = "Enhancing Magic"
	ACTION_NAME = "Haste"

	helpers.GenericAbilityHandler(self.sets, 'midcast')
end	

function TestHelpers:testMainJob()
	EXPECTED_SET = { Head = "Test", Hands = "Test"}
	PLAYER_MAINJOB = "COR"
	ACTION_TYPE = "Quick Draw"
	ACTION_NAME = "Chaos Roll"

	helpers.GenericAbilityHandler(self.sets, 'ability')
end

function TestHelpers:testSubJob()
	EXPECTED_SET = { Head = "Test", Body = "Test" }
	PLAYER_SUBJOB = "NIN"
	ACTION_NAME  = "Utsusemi: Ichi"

	helpers.GenericAbilityHandler(self.sets, 'precast')
end

function TestHelpers:testBaseName()
	EXPECTED_SET = { Head = "Test", Hands = "Test"}
	ACTION_NAME = "Cure II"

	helpers.GenericAbilityHandler(self.sets, 'midcast')
end

function TestHelpers:testActionName()
	EXPECTED_SET = {Head = "Test", Legs = "Test" }
	ACTION_NAME = "Fire III"

	helpers.GenericAbilityHandler(self.sets, 'midcast')
end

--[[
	This area will be replaced with mode handler tests once modes has been
	unit tested.
]]

function TestHelpers:testBuffs()
	EXPECTED_SET = { Head = "Test", Body = "Test" }
	gData.buffCounts['Warcry'] = 1
	ACTION_NAME = "Savage Blade"

	helpers.GenericAbilityHandler(self.sets, 'weaponskill')
end
