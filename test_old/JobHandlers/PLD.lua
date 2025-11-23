---@diagnostic disable: missing-fields
---@type jobHandler
local paladin = require('handlers.JOB.PLD')
local lu = require('luaunit')

TestPaladin = {
	sets = T{
		midcast = T{
			enmity = T{
				Head = '1'
			}
		},
		ability = T{
			enmity = T{
				Body = '1'
			}
		}
	}
}

function TestPaladin:testMidcastMissing()
	lu.assertNotEquals(paladin.midcast, nil)
	lu.assertEquals(paladin.midcast({}, {}), false)
end

function TestPaladin:testAbilityMissing()
	lu.assertNotEquals(paladin.ability, nil)
	lu.assertEquals(paladin.ability({}, {}), false)
end

function TestPaladin:testMidcast()
	lu.assertEquals(paladin.midcast({
		Name = "Flash"
	}, self.sets), { Head = "1" })
	lu.assertFalse(paladin.midcast({Name = 'Cure II'}, {midcast = {}}))
end

function TestPaladin:testAbility()
	lu.assertEquals(paladin.ability({
		Name = "Sentinel"
	}, self.sets), { Body = '1' })
	lu.assertFalse(paladin.ability({Name = "Invincible"},{ability = {}}))
end
