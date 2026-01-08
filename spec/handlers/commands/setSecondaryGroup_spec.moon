describe 'setSecondaryGroup command', ->
	local Handler
	setup ->
		_G.Helpers = mock({AddModHeader: (s) -> s})
		_G.chat = mock({error: (s) -> s})
		_G.modes = mock({setActiveSecondaryGroup: ->})
		stub(_G, 'print')
		Handler = require('handlers.command.setSecondaryGroup')
	context 'when called with more or less than 1 argument', ->
		it 'should print an error message', ->
			Handler({})
			Handler({'a', 'a'})
			assert.stub(_G.print).was_called(2)
	context 'when called with 1 argument', ->
		it 'should pass that argument to modes.setActiveSecondaryGroup', ->
			Handler({'a'})
			assert.spy(_G.modes.setActiveSecondaryGroup).was_called_with('a')