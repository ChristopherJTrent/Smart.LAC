local lu = require('luaunit')

TestPackerBuilder = {}

function TestPackerBuilder:setUp()
	self.pb = gFunc.LoadFile('packerBuilder.lua')
end

function TestPackerBuilder:testPassNil()
	lu.assertNil(self.pb:process(nil))
end
function TestPackerBuilder:testSimpleItems()
	local sets = {
		general = {
			Idle = {
				Head = "Nyame Helm",
				Body = "Nyame Mail"
			}
		}
	}
	self.pb:process(sets)

	lu.assertItemsEquals(self.pb:get(), {"Nyame Helm", "Nyame Mail"})
end

function TestPackerBuilder:testComplexItems()
	local sets = {
		general = {
			Idle = {
				Body = {Name = "Nyame Mail", AugPath = "B"}
			}
		},
		packer = {
			{Name = "Trump Card", Quantity=99}
		}
	}

	self.pb:process(sets)
	lu.assertItemsEquals(self.pb:get(), {"Nyame Mail", {Name = "Trump Card", Quantity = 99}})
end	