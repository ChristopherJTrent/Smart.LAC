describe 'the BLU job handler', ->
	local Sets, Handler
	setup ->
		Handler = require('handlers.JOB.BLU') 
	
	it 'should exist', ->
		assert.is_not.nil Handler
	
	context 'when in midcast', ->
		setup ->
			Sets = {
				midcast: {

				}
			}
		it 'should have a midcast handler', ->
			assert.is_not.nil handler
		context 'and casting a hate spell', ->
			local hatespells
			setup ->
				Sets.midcast.enmity = {
					Head: 'test'
				}
				hatespells = {
					"Blank Gaze",
					"Jettatura",
					"Sheep Song",
					"Stinking Gas",
					"Geist Wall",
					"Soporific",
					"Cold Wave"
				}
			
			it 'should not return false', ->
				assert.is_not.false Handler.midcast
			it 'should return the enmity set for any of the common enmity spells', ->
				for spell in *hatespells
					assert.is.same Sets.midcast.enmity, Handler.midcast({Name: spell}, sets)
			