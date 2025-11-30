describe 'PLD job handler', ->
	local Handler, Sets
	setup ->
		Handler = require('handlers.JOB.PLD')

	it 'should exist', ->
		assert.is_not.nil Handler
	it 'should define a midcast handler', ->
		assert.is_not.nil Handler.midcast
	it 'should define an ability handler', ->
		assert.is_not.nil Handler.ability

	context 'when in midcast', ->
		local EnmitySpellAction, BLUHateTools
		
		setup ->
			Sets = {
				midcast: {
					enmity: {
						Head: 'test'
					}
				}
			}
			EnmitySpellAction = {Name: 'Flash'}
			BLUHateTools = {"Blank Gaze", "Jettatura", "Sheep Song", "Stinking Gas", "Geist Wall", "Soporific", "Cold Wave" }
		
		it 'should handle Flash', ->
			assert.same Sets.midcast.enmity, Handler.midcast(EnmitySpellAction, Sets)
		it 'should not handle BLU spells', ->
			for spell in *BLUHateTools
				assert.is.false Handler.midcast({Name: spell}, Sets)

		context 'when no midcast enmity set is defined', ->
			setup ->
				Sets = {midcast: {}}
			it 'should return false', ->
				assert.is.false(Handler.midcast({}, Sets))

		context 'when no midcast table exists', ->
			it 'should return false', ->
				assert.is.false Handler.midcast({}, {})

	context 'when using an ability', ->
		local EnmityJAs
		setup ->
			Sets = {
				ability: {
					enmity: {
						Head: 'test'
					}
				}
			}
			EnmityJAs = { "Shield Bash",
                "Sentinel",
                "Rampart",
                "Palisade",
                "Majesty",
                "Divine Emblem",
                "Fealty",
                "Chivalry",
                "Intervene"
			}
		it 'should handle all enmity JAs', ->
			for ability in *EnmityJAs
				assert.is.same Sets.ability.enmity, Handler.ability({Name: ability}, Sets)
		
		context 'when no enmity set for abilities is defined', ->
			it 'should return false', ->
				assert.is.false Handler.ability({}, {ability: {}})
		context 'when no ability table is defined', ->
			it 'should return false', ->
				assert.is.false Handler.ability({}, {})
		