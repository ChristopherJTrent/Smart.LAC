describe 'RDM job handler', ->
	local Sets, Handler, Spell
	setup ->
		Handler = require('handlers.JOB.RDM')
	
	it 'should not be nil', ->
		assert.is_not.nil Handler
	it 'should define a midcast handler', ->
		assert.is_not.nil Handler.midcast
		assert.is.equal 'function', type(Handler.midcast)
	
	context 'when no midcast set is defined', ->
		setup ->
			Sets = {}
		
		it 'should return false', ->
			assert.is.false Handler.midcast({}, Sets)
		
	context 'when casting Enfeebling Magic', ->
		local EnfeebGroups 
		setup ->
			Sets = {
				midcast: {
					'Enfeebling Magic': {
						highSkill: {Head: 1}
						lowSkill: {Head: 2}
						skill: {Head: 3}
						duration: {Head: 4}
						mAccDuration: {Head: 5}
						mAccPotency: {Head: 6}
						mAcc: {Head: 7}
						MND: {Head: 8}
						INT: {Head: 9}
					}
				}
			}

			EnfeebGroups = {
                {Name: "highSkill", Spells: T{"Distract III", "Frazzle III"} }
                {Name: "lowSkill", Spells: T{"Poison", "Poison II"} }
                {Name: "duration", Spells: T{"Inundation"}}
                {Name: "mAccDuration", Spells: T{"Sleep", "Sleep II", "Bind", "Break", "Silence"}}
                {Name: "mAccPotency", Spells: T{"Gravity", "Gravity II"}}
                {Name: "mAcc", Spells: T{"Frazzle", "Frazzle II", "Dispel", "Distract", "Distract II"}}
                {Name: "MND", Spells: T{"Paralyze", "Paralyze II", "Addle", "Addle II", "Slow", "Slow II"}}
                {Name: "INT", Spells: T{"Blind", "Blind II"}}
            }
		it 'should return the appropriate set for the casted spell', ->
			for group in *EnfeebGroups
				for spell in *group.Spells
					assert.is.same Sets.midcast['Enfeebling Magic'][group.Name], Handler.midcast({Name: spell, Skill: 'Enfeebling Magic'}, Sets)
					
		context 'a more specific skill set isn\'t defined', ->
			local Group
			setup ->
				Group = {Name: "skill", Spells: T{"Distract III", "Frazzle III", "Poison", "Poison II"}}
				Sets.midcast['Enfeebling Magic'].highSkill = nil
				Sets.midcast['Enfeebling Magic'].lowSkill = nil

			it 'should fallback to the `skill` set if a more specific one isn\'t present', ->
				for spell in *Group.Spells
					assert.is.same Sets.midcast['Enfeebling Magic'].skill, Handler.midcast({Name: spell, Skill: 'Enfeebling Magic'}, Sets)

		context 'when only a default set is defined', ->
			local SpellAction
			setup ->
				SpellAction = {Name: "Distract III", Skill: "Enfeebling Magic"}
				Sets = {
					midcast: {
						'Enfeebling Magic': {
							default: {Head: 1}
						}
					}
				}
			it 'should return the default set', ->
				assert.is.same Sets.midcast['Enfeebling Magic'].default, Handler.midcast(SpellAction, Sets)

		context 'when no appropriate sets are defined', ->
			local SpellAction
			setup ->
				SpellAction = {Name: 'Distract III', Skill: 'Enfeebling Magic'}
				Sets = {
					midcast: {
						'Enfeebling Magic': {
							Head: 1
						}
					}
				}

			it 'should return false', ->
				assert.is.false Handler.midcast(SpellAction, Sets)
	context 'when casting Enhancing Magic', ->
		local Groups
		context 'if there is no midcast set for it', ->
			setup ->
				Sets = {
					midcast: {
						
					}
				}
			
			it 'should return false', ->
				assert.is.false Handler.midcast({Skill: 'Enhancing Magic'}, Sets)

		context 'if there is only a regular enhancing set', ->
			setup ->
				Sets = {
					midcast: {
						'Enhancing Magic':{
							Head: 1
						}
					}
				}
			
			it 'should return false', ->
				assert.is.false Handler.midcast({Skill: 'Enhancing Magic', Name: ''}, Sets)
	
		context 'when specialized sets are defined', ->
			setup ->
				Groups = {
					{Name: 'skill', Spells: {'Aquaveil', 'Stoneskin', 'Temper', 'Temper II'}}
					{Name: 'duration', Spells: {'Blink', 'Haste', 'Haste II', 'Flurry', 'Flurry II'}}
				}
				Sets = {
					midcast: {
						'Enhancing Magic': {
							skill: {
								Head: 1
							}
							duration: {
								Head: 2
							}
						}
					}
				}
			context 'and no default set is defined', ->
				it 'should return the appropriate specialized set', ->
					for group in *Groups
						for spell in *group.Spells
							assert.is.same Sets.midcast['Enhancing Magic'][group.Name], Handler.midcast({Skill: 'Enhancing Magic', Name: spell}, Sets)
				it 'should return duration gear for barspells', ->
					assert.is.same Sets.midcast['Enhancing Magic'].duration, Handler.midcast({Skill: 'Enhancing Magic', Name: 'Barfire'}, Sets)
				it 'should return skill gear for enspells', ->
					assert.is.same Sets.midcast['Enhancing Magic'].skill, Handler.midcast({Skill: 'Enhancing Magic', Name: 'Enfire'}, Sets)
				
				context 'when casting gainspells', ->
					context 'with a skill set but without a gainspell set', ->
						it 'should return the skill set', ->
							assert.is.same Sets.midcast['Enhancing Magic'].skill, Handler.midcast({Skill: 'Enhancing Magic', Name: 'Gain-MND'}, Sets)
					
					context 'with a gainspell set and a skill set', ->
						local Set
						setup ->
							Sets.midcast['Enhancing Magic'].gainspell = {Body: 1}
							Set = {Head: 1, Body: 1}
						teardown ->
							Sets.midcast['Enhancing Magic'].gainspell = nil
						it 'should return the union of those sets', ->
							assert.is.same Set, Handler.midcast({Skill: 'Enhancing Magic', Name: 'Gain-MND'}, Sets)
						
					context 'with only a gainspell set', ->
						setup ->
							Sets.midcast['Enhancing Magic'].gainspell = {Body: 1}
							Sets.midcast['Enhancing Magic'].skill = nil
						it 'should return the gainspell set', ->
							assert.is.same Sets.midcast['Enhancing Magic'].gainspell, Handler.midcast({Skill: 'Enhancing Magic', Name: 'Gain-MND'}, Sets)
					
			context 'with a default set defined', ->
				setup ->
					Sets.midcast['Enhancing Magic'].default = {
						Ring1: 1
						Head: 0
					}
				it 'should return the union of the default and specialized sets', ->
					for group in *Groups
						for spell in *group.Spells
							print(group.Name)
							assert.is.same {
								Head: Sets.midcast['Enhancing Magic'][group.Name].Head,
								Ring1: Sets.midcast['Enhancing Magic'].default.Ring1
							}, Handler.midcast({Name: spell, Skill: 'Enhancing Magic'}, Sets)
				it 'should return default U duration for barspells', ->
					assert.is.same {
						Head: 2
						Ring1: 1
					}, Handler.midcast({Name: 'Barwater', Skill: 'Enhancing Magic'}, Sets)
				context 'when casting a gainspell', ->
					context 'with a skill set and no gainspell set', ->
						it 'should return default U skill', ->
							assert.is.same {
								Head: 1
								Ring1: 1
							}, Handler.midcast({Name: 'Gain-MND', Skill: 'Enhancing Magic'}, Sets)
					context 'with both a skill and gainspell set', ->
						setup ->
							Sets.midcast['Enhancing Magic'].gainspell = {
								Ring2: 1
							}
						it 'should return default U skill U gainspell', ->
							assert.is.same {
								Head: 1
								Ring1: 1
								Ring2: 1
							}, Handler.midcast({Name: 'Gain-MND', Skill: 'Enhancing Magic'}, Sets)
					context 'with only a gainspell set', ->
						setup ->
							Sets.midcast['Enhancing Magic'].gainspell = {
								Ring2: 1
							}
							Sets.midcast['Enhancing Magic'].skill = nil
						it 'should return default U gainspell', ->
							assert.is.same {
								Head: 0
								Ring1: 1
								Ring2: 1
							}, Handler.midcast({Name: 'Gain-MND', Skill: 'Enhancing Magic'}, Sets)