local bard = require('handlers.JOB.BRD')
local lu = require('luaunit')

TestBard = {}
function TestBard:testExists()
	lu.assertNotEquals(bard, nil)
end
function TestBard:testDummySongs()
	local sets = {
		midcast = {
			dummySongs = {
				Body = "Fili Hongreline +3"
			}
		},
		settings = {
			DummySongs = {
				"Fowl Aubade"
			}
		}
	}
	lu.assertEquals(bard.midcast({Type = "Bard Song", Name = "Fowl Aubade"}, sets), {Body = "Fili Hongreline +3"})
end	

function TestBard:testRegularSongs()
	local sets = T{
		midcast = T{
			dummySongs = T{
				Body = "Fili Hongreline +3"
			}
		},
		settings = T{
			DummySongs = T{
				"Fowl Aubade"
			}
		}
	}
	lu.assertEquals(bard.midcast({Type = "Bard Song", Name = "Valor Minuet V"}, sets), false)
end