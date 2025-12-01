describe 'DNC job handler', ->
	Handler = require('handlers.JOB.DNC')
	context 'in ability handler', ->
		context 'when no ability set is defined', ->
			it 'should return false', ->
				assert.is.false Handler.ability({}, {})
		context 'without a default ability set', ->
			context 'when using a Jig', ->
				Ability = {Name: 'Spectral Jig'}
				context 'without a jigs set defined', ->
					Sets = {ability: {}}
					it 'should return false', ->
						assert.is.false Handler.ability(Ability, Sets)
				context 'with a jigs set defined', ->
					Sets = {ability: jigs: Head: 1}
					it 'should return the jigs set', ->
						assert.is.same Sets.ability.jigs, Handler.ability(Ability, Sets)
			
			context 'when using a Step', ->
				Ability1 = {Name: 'Box Step'}
				Ability2 = {Name: 'Quickstep'}
				Sets = {ability: {}}
				context 'without a steps set defined', ->
					it 'should return false', ->
						assert.is.false Handler.ability(Ability1, Sets)
						assert.is.false Handler.ability(Ability2, Sets)
				context 'with a steps set defined', ->
					Sets = {ability: steps: Head: 1}
					it 'should return the steps set', ->
						assert.is.same Sets.ability.steps, Handler.ability(Ability1, Sets)
						assert.is.same Sets.ability.steps, Handler.ability(Ability2, Sets)
			
			context 'when using a samba', ->
				Ability = {Name: 'Haste Samba'}
				Sets = {ability: {}}
				context 'without a samba set defined', ->
					it 'should return false', ->
						assert.is.false Handler.ability(Ability, Sets)
				context 'with a samba set defined', ->
					Sets.ability.sambas = {Head: 1}
					it 'should return the samba set', ->
						assert.is.same Sets.ability.sambas, Handler.ability(Ability, Sets)
			context 'when using a waltz', ->
				Ability = {Name: 'Curing Waltz III'}
				Sets = {ability: {}}
				context 'without a waltz set defined', ->
					it 'should return false', ->
						assert.is.false Handler.ability(Ability, Sets)
				context 'with a waltz set defined', ->
					Sets.ability.waltzes = {Head: 1}
					it 'should return the waltzes set', ->
						assert.is.same Sets.ability.waltzes, Handler.ability(Ability, Sets)
		context 'with a default ability set', ->
			Sets = {ability: default: Body: 1}
			context 'when using a jig', ->
				Ability = {Name: 'Spectral Jig'}
				context 'with a jigs set defined', ->
					Sets.ability.jigs = {Head: 1}
					UnionSet = {Head: 1, Body: 1}
					it 'should return the union of the default and jigs sets', ->
						assert.is.same UnionSet, Handler.ability(Ability, Sets)
			context 'when using a step', ->
				Ability1 = Name: 'Box Step'
				Ability2 = Name: 'Quickstep'
				context 'with a steps set defined', ->
					Sets.ability.steps = {Head: 1}
					UnionSet = {Head: 1, Body: 1}
					it 'should return the union of the default and steps sets', ->
						assert.is.same UnionSet, Handler.ability(Ability1, Sets)
						assert.is.same UnionSet, Handler.ability(Ability2, Sets)
			context 'when using a samba', ->
				Ability = Name: 'Haste Samba'
				context 'with a sambas set defined', ->
					Sets.ability.sambas = Head: 1
					UnionSet = Head: 1, Body: 1
					it 'should return the union of the default and steps sets', ->
						assert.is.same UnionSet, Handler.ability(Ability, Sets)