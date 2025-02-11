---@diagnostic disable: missing-fields
---@type jobHandler
local redMage = require('handlers.JOB.RDM')
local lu = require('luaunit')

TestRedMage = {
	sets = T{
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
			},
			['Enhancing Magic'] = T{
				default = T{
					Head = '1',
				},
				skill = T{
					Body = '1',
				},
				duration = T{
					Hands = '1'
				},
				gainspell = T{
					Legs = '1'
				}
			}
		}
	}
}

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
			},
			['Enhancing Magic'] = T{
				default = T{
					Head = '1',
				},
				skill = T{
					Body = '1',
				},
				duration = T{
					Hands = '1'
				},
				gainspell = T{
					Legs = '1'
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
function TestRedMage:testMidcastGenericEnfeebling()
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
		Skill = "Enfeebling Magic",
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
	lu.assertEquals(redMage.midcast({
		Name = "Inundation",
		Skill = "Enfeebling Magic"
	}, self.sets), {
		Head = '1',
		Feet = '1'
	})
	lu.assertEquals(redMage.midcast({
		Name = "Sleep II",
		Skill = "Enfeebling Magic"
	}, self.sets), {
		Head = '1',
		Ring1 = '1'
	})
	lu.assertEquals(redMage.midcast({
		Name = "Gravity",
		Skill = "Enfeebling Magic"
	}, self.sets), {
		Head = '1',
		Ring2 = '1'
	})
	lu.assertEquals(redMage.midcast({
		Name = "Frazzle",
		Skill = "Enfeebling Magic"
	}, self.sets), {
		Head = '1',
		Ear1 = '1'
	})
	lu.assertEquals(redMage.midcast({
		Name = "Paralyze II",
		Skill = "Enfeebling Magic"
	}, self.sets), {
		Head = '1',
		Back = '1'
	})
	lu.assertEquals(redMage.midcast({
		Name = "Blind",
		Skill = "Enfeebling Magic"
	}, self.sets), {
		Head = '1',
		Waist = '1'
	})
end

function TestRedMage:testDefaultSet()
	lu.assertEquals(redMage.midcast({
		Name = "test",
		Skill = "Enfeebling Magic"
	}, self.sets), {
		Head = '1'
	})
end

function TestRedMage:testMidcastGenericEnhancing()
	local sets = {
		midcast = {
			['Enhancing Magic'] = {
				Head = "test"
			}
		}
	}
	
	lu.assertEquals(redMage.midcast({
		Skill = "Enhancing Magic", 
		Name = "Haste II"
	}, sets), false)
end

function TestRedMage:testMidcastSpecializedEnhancing()
	lu.assertEquals(redMage.midcast({
		Name = "Aquaveil", 
		Skill = "Enhancing Magic"
	}, self.sets), {
		Head = '1',
		Body = '1'
	})
	lu.assertEquals(redMage.midcast({
		Name = "Haste II", 
		Skill = "Enhancing Magic"
	}, self.sets), {
		Head = '1',
		Hands = '1'
	})
end

function TestRedMage:testBarspell()
	lu.assertEquals(redMage.midcast({
		Name = "Barwater",
		Skill = "Enhancing Magic"
	}, self.sets), {
		Head = '1',
		Hands = '1'
	})
end

function TestRedMage:testEnspell()
	lu.assertEquals(redMage.midcast({
		Name = "Enwater",
		Skill = "Enhancing Magic"
	}, self.sets), {
		Head = '1',
		Body = '1'
	})
	lu.assertEquals(redMage.midcast({
		Name = "Enwater II",
		Skill = "Enhancing Magic"
	}, self.sets), {
		Head = '1',
		Body = '1'
	})
end

function TestRedMage:testMidcastGainspell()
	lu.assertEquals(redMage.midcast({
		Name = "Gain-STR", 
		Skill="Enhancing Magic"
	}, self.sets), {
		Head = '1',
		Body = '1',
		Legs = '1'
	})
end

function TestRedMage:testMidcastDefault()
	lu.assertEquals(redMage.midcast({
		Name = "Shell",
		Skill = "Enhancing Magic"
	}, self.sets), {
		Head = '1'
	})
end