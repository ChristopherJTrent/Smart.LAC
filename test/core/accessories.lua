---@diagnostic disable: missing-fields
---@type accessories
local accessories = require('accessories')
local helpers = require('helpers')
local lu = require('luaunit')

TestAccessories = {}

function TestAccessories:setUp()
	PLAYER_MAINJOB_LEVEL = 1
end

function TestAccessories:testBelt()
	lu.assertNotNil(accessories.DoBelt)
	lu.assertNotNil(accessories.DoBeltAndGorget)
	lu.assertNil(accessories.DoBeltAndGorget(1, {}))
	PLAYER_MAINJOB_LEVEL = 99
	EXPECTED_SET = {Waist = "Thunder Belt"}
	accessories.DoBelt(helpers.GetWeaponskillProperty({Id = 1}), T{
		ownedBelts = T{
			['Thunder Belt'] = true
		}
	})
	accessories.DoBelt(helpers.GetWeaponskillProperty({Id = 1}), T{
		ownedBelts = T{	
			['Flame Belt'] = true,
			['Thunder Belt'] = true
		}
	})
	EXPECTED_SET = { Waist = "Flame Belt" }
	accessories.DoBelt(helpers.GetWeaponskillProperty({Id = 15}), T{
		ownedBelts = T{
			['Flame Belt'] = true,
			['Thunder Belt'] = true
		}
	})

	EXPECTED_SET = { Waist = 'Fotia Belt' }
	accessories.DoBelt(helpers.GetWeaponskillProperty({Id = 1}), T{
		ownedBelts = T{
			['Fotia Belt'] = true
		}
	})
end

function TestAccessories:testGorget()
	lu.assertNotNil(accessories.DoGorget)
	lu.assertNotNil(accessories.DoBeltAndGorget)
	lu.assertNil(accessories.DoBeltAndGorget(1, {}))
	PLAYER_MAINJOB_LEVEL = 99
	EXPECTED_SET = { Neck = "Thunder Gorget" }
	accessories.DoGorget(helpers.GetWeaponskillProperty({Id = 1}), T{
		ownedGorgets = T{
			['Thunder Gorget'] = true
		}
	})
	accessories.DoGorget(helpers.GetWeaponskillProperty({Id = 1}), T{
		ownedGorgets = T{
			['Flame Gorget'] = true,
			['Thunder Gorget'] = true
		}
	})
end