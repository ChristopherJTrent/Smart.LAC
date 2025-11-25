describe 'NIN job handler', ->
	local Sets, Handler
	setup ->
		Handler = require('handlers.JOB.NIN')
	it 'should exist', ->
		assert.is_not.nil Handler
	
	context 'when in precast', ->
		context 'when no precast set is defined', ->
			it 'should return false', ->
				assert.is.false Handler.precast({}, {})
		
		context 'when casting Utsusemi', ->
			local UtsusemiAction
			setup ->
				UtsusemiAction = {Name: 'Utsusemi: Ichi'}
			context 'with an utsusemi set defined', ->
				setup ->
					Sets = {
						precast: {
							utsusemi: {
								Head: 'test'
							}
						}
					}
				it 'should not return false', ->
					assert.is_not.false Handler.precast(UtsusemiAction, Sets)
				it 'should return the utsusemi set', ->
					assert.is.same Sets.precast.utsusemi, 
						Handler.precast(UtsusemiAction, Sets)
			context 'without an utsusemi set defined', ->
				setup ->
					Sets = {precast: {}}
				
				it 'should return false', ->
					assert.is.false Handler.precast(UtsusemiAction, Sets)