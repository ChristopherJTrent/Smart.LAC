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
							}
						}
					it 'should return that default set', ->
						for name in *barElement
							assert.is.same Sets.midcast.default,
								Handler.midcast({Name: name}, Sets)
					context ''