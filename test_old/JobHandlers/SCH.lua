---@diagnostic disable: missing-fields
---@type jobHandler
local scholar = require('handlers.JOB.SCH')
local lu = require('luaunit')

TestScholar = {
	sets = T{
		midcast = T{
			helix = T{
				Head = '1',
			},
			storm = T{
				Body = '1'
			}
		}
	}
}

function TestScholar:testMissingMidcast()
	lu.assertNotEquals(scholar.midcast, nil)
	lu.assertEquals(scholar.midcast({}, {}), false)
end

function TestScholar:testHelix()
	lu.assertEquals(scholar.midcast({
		Name = "Anemohelix"
	}, self.sets), { Head = '1' })
end

function TestScholar:testStorm()
	lu.assertEquals(scholar.midcast({
		Name = "Aurorastorm"
	}, self.sets), { Body = '1' })
end

