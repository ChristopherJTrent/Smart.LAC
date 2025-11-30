describe "COR Job Handler", ->
	local Handler, Sets
	setup ->
		Handler = require 'handlers.JOB.COR'
		Sets = {}

	it 'should exist', ->
		assert.is_not.nil Handler
	context 'when Phantom Roll is used', ->
		local PRAction
		setup ->
			Sets = {
				ability: {
					phantomRoll: {
						Head: "test"
					}
				}
			}
			PRAction = { Type: 'Corsair Roll', Name: 'Chaos Roll'}

		it 'should not return false', ->
			assert.is_not.false Handler.ability(PRAction, Sets)
		it 'should return the phantomRoll set', ->
			assert.is.same Sets.ability.phantomRoll, Handler.ability(PRAction, Sets)
		context 'when no phantomRoll set is defined', ->
			setup ->
				Sets = {ability: {}}
			it 'should return false', ->
				assert.is.false Handler.ability(PRAction, Sets)

	context 'when Double-Up is used', ->
		local DUAction
		setup ->
			Sets = {
				ability: {
					phantomRoll: {
						Head: 'test'
					}
				}
			}
			DUAction = {Name: 'Double-Up'}

		it 'should not return false', ->
			assert.is_not.false Handler.ability(DUAction, Sets)
		it 'should return the phantomRoll set', ->
			assert.is.same Sets.ability.phantomRoll, Handler.ability(DUAction, Sets)
		context 'when no phantomRoll set is defined', ->
			setup ->
				Sets = {ability: {}}
			it 'should return false', ->
				assert.is.false Handler.ability(DUAction, Sets)
	
	context 'when Quick Draw is used', ->
		local QDAction
		setup ->
			Sets = {
				ability: {
					quickDraw: {
						Feet: 'Chass. Bottes +3'
					}
				}
			}
			QDAction = {Type: 'Quick Draw', Name: 'Fire Shot'}
		it 'should not return false', ->
			assert.is_not.false Handler.ability(QDAction, Sets)
		it 'should return the quickDraw set', ->
			assert.is.same Sets.ability.quickDraw, Handler.ability(QDAction, Sets)
	context 'when any other ability is used', ->
		it 'should return false', ->
			assert.is.false Handler.ability({Name: 'Divine Seal'}, {ability: {}})
	