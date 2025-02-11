---@type jobHandler
local corsair = require('handlers.JOB.COR')
local lu = require('luaunit')

TestCorsair = {
	sets = T{
		ability = T{
			phantomRoll = T{
				Head = '1'
			},
			quickDraw = T{
				Body = '1'
			}
		}
	}
}

function TestCorsair:testOtherAction() 
	lu.assertEquals(corsair.ability({
		Name = "Warcry",
		ActionType = "Ability"
	}, self.sets), false)
end

function TestCorsair:testPhantomRoll()
	lu.assertEquals(corsair.ability({
		Name = "Chaos Roll",
		ActionType = "Ability",
		Type = "Corsair Roll"
	}, self.sets), {Head = "1"})
	lu.assertEquals(corsair.ability({
		Name = "Double-Up",
		ActionType = "Ability"
	}, self.sets), {Head = "1"})
end

function TestCorsair:testQuickDraw()
	lu.assertEquals(corsair.ability({
		Name = "Light Shot",
		ActionType = "Ability",
		Type = "Quick Draw"
	}, self.sets), {Body = '1'})
end