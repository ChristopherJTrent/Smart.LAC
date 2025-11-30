describe 'SCH job handler', ->
	local Handler, Sets
	setup ->
		Handler = require('handlers.JOB.SCH')
		Sets = {}
	it 'should exist', ->
		assert.is_not.nil Handler
	context 'midcast handler', ->
		it 'should exist', ->
			assert.is_not.nil Handler.midcast
		context 'when no midcast set is defined', ->
			it 'should return false', ->
				assert.is.false Handler.midcast({}, Sets)
		context 'when a midcast set is defined', ->
			setup ->
				Sets = {
					midcast: {

					}
				}
			context 'and the player is casting a helix spell', ->
				context 'with a helix set defined', ->
					setup ->
						Sets.midcast.helix = {
							Head: 1
						}
					it 'should return the helix set', ->
						assert.is.same Sets.midcast.helix, Handler.midcast({Name: 'Ionohelix', Skill: 'Elemental Magic'}, Sets)
				context 'without a helix set defined', ->
					setup ->
						Sets.midcast = {}
					it 'should return false', ->
						assert.is.false, Handler.midcast({Name: 'Ionohelix', Skill: 'Elemental Magic'}, Sets)
			context 'and the player is casting a storm spell', ->
				context 'with a storm set defined', ->
					setup ->
						Sets.midcast.storm = {
							Head: 1
						}
					it 'should return the storm set', ->
						assert.is.same Sets.midcast.storm, Handler.midcast({Name: 'Thunderstorm', Skill: 'Enhancing Magic'}, Sets)
				context 'without a storm set defined', ->
					setup ->
						Sets.midcast = {}
					it 'should return false', ->
						assert.is.false Handler.midcast({Name: 'Hailstorm II', Skill: 'Enhancing Magic'}, Sets)
