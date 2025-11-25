describe 'GEO job handler', ->
	local Handler
	setup ->
		Handler = require('handlers.JOB.GEO')
	
	it 'should exist', ->
		assert.is_not.nil Handler
	context 'during midcast', ->
		local Sets
		it 'should have a handler', ->
			assert.is_not.nil Handler.midcast

		context 'when no midcast set is defined', ->
			setup ->
				Sets = {}
			it 'should return false', ->
				assert.is.false Handler.midcast({}, Sets)
	
		context 'when casting a geocolure', ->
			local GeocolureAction
			setup ->
				Sets = {
					midcast: {
						geocolure: {
							Head: 'test'
						}
					}
				}
				GeocolureAction = {Name: 'Geo-Malaise'}
			it 'should not return false', ->
				assert.is_not.false Handler.midcast(GeocolureAction, Sets)
			it 'should return the geocolure set', ->
				assert.is.same Sets.midcast.geocolure, 
					Handler.midcast(GeocolureAction, Sets)

		context 'when casting an indicolure', ->
			local IndicolureAction
			setup ->
				Sets = {
					midcast: {
						indicolure: {
							Head: 'test'
						}
					}
				}
				IndicolureAction = {Name: 'Indi-Regen'}
			it 'should not return false', ->
				assert.is_not.false Handler.midcast(IndicolureAction, Sets)
			it 'should return the indicolure set', ->
				assert.is.same Sets.midcast.indicolure, 
					Handler.midcast(IndicolureAction, Sets)
		context 'when casting any other spell', ->
			local SpellAction
			setup ->
				Sets = {
					midcast: {}
				}
				SpellAction = {Type: 'White Magic', Name: 'Curaga III'}
			it 'should return false', ->
				assert.is.false Handler.midcast(SpellAction, Sets)