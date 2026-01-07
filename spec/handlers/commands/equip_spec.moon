describe 'equip command', ->
	Handler = require('handlers.command.equip')
	setup ->
		_G.modes = mock({
			
			getSets: -> a:{ a: {a: {a: {a:{}}}}}
		}, false)
		_G.gFunc = mock({
			LockSet: -> 
		}, false)
	context 'when called with 1 argument', ->
		it 'should print an error message', ->
			stub(_G, "print")
			Handler({''})
			assert.stub(_G.print).was.called()
			_G.print\revert()
	context 'when called with more than 1 arguments', ->
		it 'should call LockSet with the appropriate set, and a time of 15 seconds', ->
			Handler({'a', 'a'})
			Handler({'a', 'a', 'a'})
			Handler({'a','a','a','a'})
			Handler({'a','a','a','a','a'})
			assert.spy(_G.gFunc.LockSet).was_called_with({a: {a: {a:{}}}}, 15)
			assert.spy(_G.gFunc.LockSet).was_called_with({a: {a: {}}}, 15)
			assert.spy(_G.gFunc.LockSet).was_called_with({a: {}}, 15)
			assert.spy(_G.gFunc.LockSet).was_called_with({}, 15)
