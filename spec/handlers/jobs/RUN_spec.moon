describe 'RUN job handler', ->
	local Handler, Sets
	setup ->
		Handler = require 'handlers.JOB.RUN'
	it 'should exist', ->
		assert.is_not.nil Handler
	it 'should define all relevant handlers', ->
		assert.is_not.nil Handler.midcast
		assert.is_not.nil Handler.ability
	context 'in midcast', ->
		context 'when a midcast table is not defined', ->
			setup ->
				Sets = {}
			it 'should return false', ->
				assert.is.false Handler.midcast({}, Sets)
		context 'when no specialized midcast sets are defined', ->
			setup ->
				Sets = {
					midcast: {}
				}
			it 'should return false', ->
				assert.is.false Handler.midcast({}, Sets)
				assert.is.false Handler.midcast({Name: 'Flash'}, Sets)
				assert.is.false Handler.midcast({Name: 'Phalanx'}, Sets)
		context 'when an enmity midcast set is defined', ->
			local bluHate
			setup ->
				Sets = {
					midcast: {
						enmity: {
							Head: 'foo'
						}
					}
				}
				bluHate = {
					"Blank Gaze",
					"Jettatura",
					"Sheep Song",
					"Stinking Gas",
					"Geist Wall",
					"Soporific",
					"Cold Wave"
				}
			it 'should return that set for both Flash and Foil', ->
				assert.is.same Sets.midcast.enmity,
					Handler.midcast({Name: 'Flash'}, Sets)
				assert.is.same Sets.midcast.enmity,
					Handler.midcast({Name: 'Foil'}, Sets)
			it 'should not handle BLU enmity spells', ->
				for spell in *bluHate
					assert.is.false Handler.midcast({Name: spell}, Sets)
		context 'when a phalanx set is defined', ->
			setup ->
				Sets = {
					midcast: {
						phalanx: {
							Head: 'foo'
						}
					}
				}
			it 'should return that set when phalanx is being cast', ->
				assert.is.same Sets.midcast.phalanx,
					Handler.midcast {Name: 'Phalanx'}, Sets
	context 'when using an ability', ->
		context 'without an ability.enmity set defined', ->
			it 'should return false', ->
				assert.is.false Handler.ability {}, {}
				assert.is.false Handler.ability {}, {ability: {}}
				assert.is.false Handler.ability {Name: 'Odyllic Subterfuge'}, {ability: {}}
		context 'when using an enmity JA', ->
			local enmityJAs
			setup ->
				enmityJAs = T{
					"Vallation",
					"Swordplay",
					"Pflug",
					"Valiance",
					"Embolden",
					"Gambit",
					"Rayke",
					"Battuta",
					"Liement",
					"One for All",
					"Odyllic Subterfuge"
				}
				Sets = {
					ability: {
						enmity: {
							Head: 'foo'
						}
					}
				}
			it 'should return the enmity set', ->
				for ability in *enmityJAs
					assert.is.same Sets.ability.enmity,
						Handler.ability {Name: ability}, Sets
		