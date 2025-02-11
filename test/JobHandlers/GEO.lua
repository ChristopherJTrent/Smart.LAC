---@diagnostic disable: missing-fields
---@type jobHandler
local geomancer = require('handlers.JOB.GEO')
local lu = require('luaunit')

TestGeomancer = T{
	sets = T{
		midcast = T{
			Geomancy = T{
				Head = '1'
			},
			geocolure = T{
				Body = '1'
			},
			indicolure = T{
				Hands = '1'
			}
		}
	}
}

function TestGeomancer:testMidcast()
	lu.assertEquals(geomancer.midcast({}, {}), false)
end

function TestGeomancer:testGeocolure()
	lu.assertEquals(geomancer.midcast({
		Name = "Geo-Frailty"
	}, self.sets), {Body = '1'})
end

function TestGeomancer:testIndicolure()
	lu.assertEquals(geomancer.midcast({
		Name = "Indi-Fury",
	}, self.sets), {Hands = '1'})
end