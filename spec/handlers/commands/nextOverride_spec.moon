describe 'nextOverride command', ->
	local Handler, print_spy
	setup ->
		Handler = require('handlers.command.nextOverride')
		_G.print = stub(_G, 'print')
		_G.modes = mock({
			nextOverrideState: ->
		})
	context 'when called with 1 argument', ->
		it 'should call modes.nextOverrideState with the argument', ->
			Handler({'foo'})
			assert.spy(_G.modes.nextOverrideState).was_called_with('foo')
	context 'when called with more or less than 1 argument', ->
		setup ->
			_G.Helpers = {
				AddModHeader: (s) -> "[Smart.LAC] "..s
			}
			_G.chat = {
				error: (s) -> s
			}
		it 'should print an error message', ->
			Handler({})
			Handler({'a', 'a'})
			assert.stub(_G.print).was_called(2)
	context 'when called with no arguments', ->
		it 'should error', ->
			assert.has_error(-> Handler())