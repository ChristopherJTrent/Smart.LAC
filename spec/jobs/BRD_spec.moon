describe "BRD job handler", ->
    setup ->
        _G.handler = require('handlers.JOB.BRD')

    it "should exist", ->
        assert.are_not.equals handler, nil
    
    describe 'midcast', ->
        local sets
        setup ->
            sets = {
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

        it "should handle dummy songs", ->
            assert.are.same {Body: "Fili Hongreline +3"}, handler.midcast({Type: "Bard Song", Name: "Fowl Aubade"}, sets)
        it "should not handle non-dummy songs", ->
            assert.is.false handler.midcast({Type: "Bard Song", Name: ""}, sets)
        it "should not handle non-songs", ->
            assert.is.false handler.midcast({Type: "White Magic", Name: ""}, sets)
