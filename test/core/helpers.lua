---@diagnostic disable: missing-fields
---@type helpers
local helpers = require('helpers')
local lu = require('luaunit')

TestHelpers = {}

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