---@diagnostic disable: missing-fields
---@type jobHandler
local ninja = require('handlers.JOB.NIN')
local lu = require('luaunit')

TestNinja = {
	sets = T{
		precast = T{
			utsusemi = T{
				Head = '1'
			}
		}
	}
}

function TestNinja:testPrecastMissing()
	lu.assertEquals(ninja.precast({}, {}), false)
end

function TestNinja:testUtsusemiPrecast()
	lu.assertEquals(ninja.precast({
		Name = "Utsusemi: Ichi"
	}, self.sets), { Head = '1' })
end