describe 'WHM job handler', ->
	local Handler, Sets
	setup ->
		require 'common'
		Handler = require 'handlers.JOB.WHM'
	it 'should exist', ->
		assert.is_not.nil Handler
	it 'should define handlers for all relevant events', ->
		assert.is_not.nil Handler.midcast
	
	context 'when casting', ->
		context 'without a midcast set', ->
			setup ->
				Sets = {}
			it 'should return false', ->
				assert.is.false Handler.midcast({}, Sets)	
		context 'Na-Spells', ->
			local Naspells
			setup ->
				Naspells = {
					'Blindna', 
					'Esuna', 
					'Paralyna', 
					'Poisona', 
					'Silena', 
					'Stona', 
					'Viruna'
				}
			context 'with a midcast default set', ->
				setup ->
					Sets = {
						midcast: {
							default: {
								Head: 'foo'
								Hands: 'foo'
							}
						}
					}
				it 'should return the default midcast set', ->
					for name in *Naspells
						assert.is.same Sets.midcast.default,
							Handler.midcast {Name: name}, Sets
				context 'and a na-spell set', ->
					setup ->
						Sets.midcast = {
							default: {
								Head: 'foo'
								Hands: 'foo'
							}
							naSpell: {
								Head: 'bar'
								Body: 'bar'
							}
						}
					it 'should return the union of those sets', ->
						for name in *Naspells
							assert.is.same {Head: 'bar', Body: 'bar', Hands: 'foo'},
								Handler.midcast({Name: name}, Sets)
			context 'with only a na-spell set', ->
				setup ->
					Sets.midcast = {
						naSpell: {
							Head: 'bar'
						}
					}
				it 'should return the na-spell set', ->
					for name in *Naspells
						assert.is.same Sets.midcast.naSpell,
							Handler.midcast {Name: name}, Sets
		context 'barspells', ->
			context 'with a base barSpell set defined', ->
				setup ->
					Sets.midcast = {
						barSpell: {
							Head: 'foo'
							Legs: 'foo'
						}
					}
			context 'of the element variety', ->
				local barElement
				setup ->
					barElement = {
						'Barfira', 
						'Barblizzara', 
						'Baraera', 
						'Barstonra', 
						'Barthundra', 
						'Barwatera'
					}
				context 'with a midcast default set', ->
					setup ->
						Sets.midcast = {
							default: {
								Head: 'bar'
								Body: 'bar'
								Hands: 'bar'
							}
						}
					it 'should return that default set', ->
						for name in *barElement
							assert.is.same Sets.midcast.default,
								Handler.midcast({Name: name}, Sets)
					context 'and a barSpell set', ->
						setup ->
							Sets.midcast.barSpell = {
								Head: 'foo'
								Feet: 'foo'
							}
						it 'should return the union of those sets', ->
							for name in *barElement
								assert.is.same gFunc.Combine(Sets.midcast.default, Sets.midcast.barSpell),
									Handler.midcast({Name: name}, Sets)
						context 'and a barElement set', ->
							setup ->
								Sets.midcast.barElement = {
									Hands: 'baz'
									Legs: 'baz'
								}
							it 'should return the union of all of those sets', ->
								for name in *barElement
									assert.is.same gFunc.Combine(gFunc.Combine(Sets.midcast.default, Sets.midcast.barSpell), Sets.midcast.barElement),
										Handler.midcast({Name: name}, Sets)
			context 'of the status variety', ->
				local barStatus
				setup ->
					barStatus = {
						'Baramnesra'
						'Barvira'
						'Barparalyzra'
						'Barsilencera'
						'Barpetra'
						'Barpoisonra'
						'Barblindra'
						'Barsleepra'
					}
				context 'with a default midcast set', ->
					setup ->
						Sets = {
							midcast: {
								default: {
									Head: 'foo'
									Body: 'foo'
									Hands: 'foo'
								}
							}
						}
					it 'should return that midcast default set', ->
						for name in *barStatus
							assert.is.same Sets.midcast.default,
								Handler.midcast({Name: name}, Sets)
					context 'and a barSpell midcast set', ->
						setup ->
							Sets.midcast.barSpell = {
								Head: 'bar'
								Legs: 'bar'
							}
						it 'should return the union of those sets', ->
							for name in *barStatus
								assert.is.same gFunc.Combine(Sets.midcast.default, Sets.midcast.barSpell),
									Handler.midcast({Name: name}, Sets)
						context 'and a barStatus midcast set', ->
							setup ->
								Sets.midcast.barStatus = {
									Body: 'baz',
									Feet: 'baz'
								}
							it 'should return the union of all three sets', ->
								for name in *barStatus
									assert.is.same gFunc.Combine(gFunc.Combine(Sets.midcast.default, Sets.midcast.barSpell), Sets.midcast.barStatus),
										Handler.midcast({Name: name}, Sets)