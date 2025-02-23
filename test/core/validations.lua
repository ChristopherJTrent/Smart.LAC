local lu = require('luaunit')

local validations = require('handlers.validations')

TestValidations = {}

function TestValidations:testValidateGeneral()
	lu.assertNotNil(validations.validateGeneral)
	lu.assertFalse(validations.validateGeneral({}))
	lu.assertFalse(validations.validateGeneral({General = {}}))
	lu.assertFalse(validations.validateGeneral({general = {}}))
	lu.assertFalse(validations.validateGeneral({general = {idle = {}}}))
	lu.assertTrue(validations.validateGeneral({general = { Idle = {}}}))
end

function TestValidations:testCheckForSets()
	lu.assertNotNil(validations.checkForDefaults)
	lu.assertTrue(validations.checkForDefaults({}))
	lu.assertFalse(validations.checkForDefaults({weaponskill = {}}))
	lu.assertFalse(validations.checkForDefaults({weaponskill = {Default = {}}}))
	lu.assertTrue(validations.checkForDefaults({weaponskill = { default = {}}}))
	lu.assertTrue(validations.checkForDefaults({
		general = {
			Idle = {}
		},
		settings = {
			DisableWeaponWarning = true
		},
		lockstyle = {
			Legs = "Arbatel Pants +2"
		},
		_disabledSet = {}
	}))
end

function TestValidations:testCombined()
	lu.assertNotNil(validations.validate)
	lu.assertFalse(validations.validate({}))
	lu.assertFalse(validations.validate({General = {}, weaponskill = {default = {}}}))
	lu.assertFalse(validations.validate({general = {Idle = {}}, weaponskill = {Default = {}}}))
	lu.assertTrue(validations.validate({general = { Idle = {}}, weaponskill = {default = {}}}))
end