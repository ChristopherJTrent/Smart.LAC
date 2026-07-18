describe 'nextSecondaryGroup command', ->
	local Handler
	setup -> 
		_G.modes = mock({nextSecondaryGroup: ->})
		Handler = require('handlers.command.nextSecondaryGroup')
	it 'should call modes.nextSecondaryGroup', ->
		Handler()
		assert.spy(_G.modes.nextSecondaryGroup).was_called()