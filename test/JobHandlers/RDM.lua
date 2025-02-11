---@type jobHandler
local redMage = require('handlers.JOB.RDM')
local lu = require('luaunit')

TestRedMage = {}

function TestRedMage:setUp()
	self.sets =  T{
		midcast = T{
			['Enfeebling Magic'] = T{
				default = T{
					Head = '1'
				},
				highSkill = T{
					Body = '1'
				},
				lowSkill = T{
					Hands = '1'
				},
				skill = T{
					Legs = '1'
				},
				duration = T{
					Feet = '1'
				},
				mAccDuration = {
					Ring1 = '1'
				},
				mAccPotency = {
					Ring2 = '1'
				},
				mAcc = {
					Ear1 = '1'
				},
				MND = {
					Back = '1'
				},
				INT = {
					Waist = '1'
				}
			}
		}
	}
end

function TestRedMage:testExists()
	lu.assertNotEquals(redMage, nil)
end

function TestRedMage:testMissingMidcast()
	lu.assertEquals(redMage.midcast({}, {}), false)
end

-- Ensures that if the midcast table is not structured for the job handler, that the handler returns gracefully.
function TestRedMage:testMidcastGeneric()
	local sets = {
		midcast = {
			['Enfeebling Magic'] = {
				Head = "test"
			}
		}
	}
	lu.assertEquals(redMage.midcast({Skill = "Enfeebling Magic"}, sets), false)
end

function TestRedMage:testSpecializedEnfeebling()
	lu.assertEquals(redMage.midcast({
		Name = "Distract III", 
		Skill = "Enfeebling Magic"
	}, self.sets), {
		Head = '1',
		Body = '1'
	})

	lu.assertEquals(redMage.midcast({
		Name = "Poison",
		Skill = "Enfeebling Magic"
	}, self.sets), {
		Head = '1',
		Hands = '1'
	})
	self.sets.highSkill = nil
	lu.assertEquals(redMage.midcast({
		Name = "Distract III",
		Skill = 'Enfeebling Magic'
	}, self.sets), {
		Head = '1',
		Legs = '1'
	})
end
