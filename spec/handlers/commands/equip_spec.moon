describe 'equip command', ->
	export modes, gFunc
	modes = mock({LockSet: -> print('')}, true)
	gFunc = mock({getSets: -> a:{ a: {a: {a: a:{}}}}})
	Handler = require('handlers.command.equip')
	context 'when called with 1 argument', ->
		it 'should print an error message', ->
			print_spy = spy.on(_G, 'print')
			export modes, gFunc
			modes = mock({LockSet: -> print('')}, true)
			gFunc = mock({getSets: -> a:{ a: {a: {a: a:{}}}}})
			Handler('')
			assert.spy(print_spy).was.called()