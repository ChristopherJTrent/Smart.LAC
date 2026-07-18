describe 'setWeaponGroup command', ->
	local Handler
	setup ->
		_G.Helpers = mock({AddModHeader: (s) -> s})
		_G.chat = mock({error: (s) -> s})
		_G.modes = mock({setActiveWeaponGroup: ->})
		stub(_G, 'print')
		Handler = require('handlers.command.setWeaponGroup')
	context 'when called with more or less than 1 argument', ->
		it 'should print an error message', ->
			Handler({})
			Handler({'a', 'a'})
			assert.stub(_G.print).was_called(2)
	context 'when called with 1 argument', ->
		it 'should pass that argument to modes.setActiveWeaponGroup', ->
			Handler({'a'})
			assert.spy(_G.modes.setActiveWeaponGroup).was_called_with('a')