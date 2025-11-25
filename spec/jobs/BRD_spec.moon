describe "BRD job handler", ->
	local Handler
    setup ->
        Handler = require('handlers.JOB.BRD')

    it "should exist", ->
        assert.are_not.equals Handler, nil

	it 'should have a midcast handler', ->
		assert.are_not.equals Handler.midcast, nil
    
    describe 'midcast', ->
        local Sets
        setup ->
            Sets = {
                midcast: {
                    dummySongs: {
                        Body: "Fili Hongreline +3"
                    }
                }
                settings: {
                    DummySongs: {
                        "Fowl Aubade"
                    }
                }
            }
		context 'when a dummy song is cast', ->
			local DummyAction
			setup ->
				DummyAction = {Type: 'Bard Song', Name: 'Fowl Aubade'}
			it 'should not return false', ->
				assert.is_not.false Handler.midcast(DummyAction, Sets)
			it 'should return the Dummy Songs set', ->
				assert.is.same Sets.midcast.dummySongs, Handler.midcast(DummyAction, Sets)
		
		context 'when a non-dummy song is cast', ->
			local SongAction
			setup ->
				SongAction = {Type: 'Bard Song', Name: 'Valor Minuet V'}
			it 'should return false', ->
				assert.is.false Handler.midcast(SongAction, Sets)
				
		context 'when any other spell is cast', ->
			local Action
			setup ->
				Action = {Type: 'White Magic', Name: 'Cure IV'}
			it 'should return false', ->
				assert.is.false Handler.midcast(Action, Sets)