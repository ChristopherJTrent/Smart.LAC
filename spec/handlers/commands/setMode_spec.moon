describe 'setMode command', ->
	local Handler
	setup ->
		_G.Helpers = mock({AddModHeader: (s) -> s})
		_G.modes = mock({setActiveMode: ->})
		stub(_G, 'print')
		Handler = require('handlers.command.setMode')
	context 'when called with any more or less than 1 argument', ->
		it 'should print an error message', ->
			Handler({})
			Handler({'a','a'})
			assert.stub(_G.print).was_called(2)
	context 'when called with 1 argument', ->
		it 'should call modes.setActiveMode with the argument', ->
			Handler({'a'})
			assert.spy(_G.modes.setActiveMode).was_called_with('a')