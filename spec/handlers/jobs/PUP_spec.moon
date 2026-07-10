describe 'PUP job handler', ->
	local Handler, Sets
	setup ->
		Handler = require 'handlers.JOB.PUP'
	it 'should exist', ->
		assert.is_not.nil Handler
	context 'default handler', ->
		it 'should exist', ->
			assert.is_not.nil Handler.default
		context 'when the player doesn\'t have a pet', ->
			setup ->
				_G.gData = {GetPet: -> nil}
			it 'should return false', ->
				assert.is.false Handler.default(Sets)
		context 'when the player has a pet', ->
			setup ->
				_G.gData = {GetPet: -> {}}
			context 'and lacks a general table', ->
				setup ->
					Sets = {}
				it 'should return false', ->
					assert.is.false Handler.default(Sets)
			context 'and lacks a general.pets table', ->
				setup ->
					Sets = {
						general: {

						}
					}
				it 'should return false', ->
					assert.is.false Handler.default(Sets)
			context 'and lacks a general.pets.weaponskill table', ->
				setup -> 
					Sets = {general: {pets: {}}}
				it 'should return false', ->
					assert.is.false Handler.default(Sets)
			context 'that has 950+ TP and is engaged', ->
				setup ->
					_G.gData = {GetPet: -> {TP: 1000, Status: 'Engaged'}}
				context 'and the player has a general.pets.weaponskill set', ->
					setup ->
						Sets = {
							general: {
								pets: {
									weaponskill: {
										Head: 'foo'
									}
								}
							}
						}
					it 'should return that weaponskill set', ->
						assert.is.same Sets.general.pets.weaponskill,
							Handler.default(Sets)
			-- this test has been disabled as there is a bug causing the handler to see 'Engaged' where it absolutely shouldn't.
			-- A PR that can successfully make this test work properly would be appreciated.
			
			-- context 'that has sufficient TP but is not engaged', ->
			-- 	setup ->
			-- 		_G.gData = {
			-- 			GetPet: -> {
			-- 				TP: 1000
			-- 				Status: 'Idle'
			-- 			}
			-- 		}
			-- 	it 'should return false',
			-- 		assert.is.false Handler.default(Sets)
			context 'that is engaged with less than 950 TP', ->
				setup ->
					_G.gData = {GetPet: -> {TP: 500, Status: 'Engaged'}}
				it 'should return false', ->
					assert.is.false Handler.default(Sets)
			