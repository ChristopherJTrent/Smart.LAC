describe 'SMN job handler', ->
	local Sets, Handler
	setup ->
		Handler = require 'handlers.JOB.SMN'
		Sets = {}
		require('common')
	it 'should exist', ->
		assert.is_not.nil Handler
	it 'should define all relevant lifecycle handlers', ->
		assert.is_not.nil Handler.default
		assert.is_not.nil Handler.ability
	context 'during default', ->
		context 'when no general.pets set is defined', ->
			setup ->
				Sets.general = {}
			it 'should return false', ->
				assert.is.false Handler.default Sets
			context 'nor a general table', ->
				setup ->
					Sets.general = nil
				it 'should return false', ->
					assert.is.false Handler.default Sets
		context 'when the player doesn\'t have a pet, or that pet is not actively using a blood pact', ->
			setup ->
				_G.gData = {GetPetAction: -> nil}
				Sets.general = {
					pets: {}
				}
			it 'should return false', ->
				assert.is.false Handler.default Sets
		context 'when the player\'s pet is using a blood pact: rage', ->
			setup ->
				_G.gData = {GetPetAction: -> {Type: 'Blood Pact: Rage'}}
			context 'with a default set defined', ->
				setup ->
					Sets.general = {
						pets: {
							default: {
								Head: 'foo'
								Body: 'foo'
							}
						}
					}
				context 'and without a blood pact set defined', ->
					it 'should return the default pet set', ->
						assert.is.same Sets.general.pets.default,
							Handler.default Sets
				context 'alongside a bloodPact set', ->
					setup ->
						Sets.general.pets.bloodPact = {
							Head: 'bar'
							Hands: 'bar'
						}
					it 'should return the union of those sets', ->
						assert.is.same gFunc.Combine(Sets.general.pets.default, Sets.general.pets.bloodPact),
							Handler.default(Sets)
		context 'when the player\'s pet is using any other kind of ability', ->
			setup ->
				_G.gData = {GetPetAction: -> {Type: 'Blood Pact: Ward'}}
			it 'should return false' , ->
				assert.is.false Handler.default Sets
	context 'during abilities', ->
		context 'without an ability set defined', ->
			it 'should return false', ->
				assert.is.false Handler.ability({}, {})
		context 'specifically blood pacts', ->
			context 'without a blood pact set', ->
				setup ->
					Sets.ability = {}
				it 'should return false', ->
					assert.is.false Handler.ability({Type: 'Blood Pact: Rage'}, Sets)
					assert.is.false Handler.ability({Type: 'Blood Pact: Ward'}, Sets)
			context 'with a blood pact set', ->
				setup ->
					Sets.ability = {
						bloodPact: {
							Head: 'foo'
							Hands: 'foo'
						}
					}
				it 'should return that set', ->
					assert.is.same Sets.ability.bloodPact,
						Handler.ability {Type: 'Blood Pact: Rage'}, Sets
					assert.is.same Sets.ability.bloodPact,
						Handler.ability {Type: 'Blood Pact: Ward'}, Sets
		context 'excluding blood pacts', ->
			setup ->
				Sets.ability = {}
			it 'should return false', ->
				assert.is.false Handler.ability {Type: 'Bah'}, Sets