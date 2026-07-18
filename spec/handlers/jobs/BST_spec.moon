describe 'BST job handler', ->
	local Sets, Handler
	setup ->
		Handler = require 'handlers.JOB.BST'
		Sets = {}
		_G.T = require 'spec.mocks.table'
		require 'spec.mocks.gFunc'
	it 'should exist', ->
		assert.is_not.nil Handler
		assert.is_not.nil Handler.default
	context 'during the default hook', ->
		context 'if no general table is defined', ->
			it 'should return false', ->
				assert.is.false Handler.default(Sets)
		context 'if no general pets table is defined', ->
			setup ->
				Sets.general = {}
			it 'should return false', ->
				assert.is.false Handler.default(Sets)
		context 'if the player either lacks a pet or their pet is idle', ->
			setup ->
				Sets.general = {
					pets: {

					}
				}
				_G.gData = mock({GetPetAction: -> nil})
			it 'should return false', ->
				assert.is.false Handler.default(Sets)
		context 'when neither a default set nor specialized set is defined', ->
			setup ->
				Sets.general = {
					pets: {

					}
				}
				_G.gData = mock({GetPetAction: -> {}})
			it 'should return false', ->
				assert.is.false Handler.default(Sets)
		context 'when a default set is defined, but not a specialized set', ->
			setup ->
				Sets.general = {
					pets: {
						default: {
							Head: 'foo'
						}
					}
				}
				_G.gData = mock({GetPetAction: -> {ActionType: 'MobSkill', Name: 'foo'}})
			it 'should return the default set', ->
				assert.is.same Sets.general.pets.default, 
					Handler.default(Sets)
		context 'when a specialized set is defined', ->
			setup ->
				_G.gData = mock({GetPetAction: -> {ActionType: 'MobSkill', Name: 'foo'}})

			context 'but not a default set', ->
				setup ->
					Sets.general = {
						pets: {
							foo: {
								Head: 'foo'
							}
						}
					}
				it 'should return just the specialized set', ->
					assert.is.same Sets.general.pets.foo,
						Handler.default(Sets)
			context 'alongside a default set', ->
				setup ->
					Sets.general = {
						pets: {
							default: {
								Head: 'foo'
								Legs: 'foo'
							}
							foo: {
								Head: 'bar'
								Body: 'foo'
							}
						}
					}
				it 'should return the default set, overlayed with the specialized set', ->
					assert.is.same gFunc.Combine(Sets.general.pets.default, Sets.general.pets.foo),
						Handler.default(Sets)