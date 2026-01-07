describe "nextMode command", ->
	local Handler
	setup ->
		_G.modes = mock({
			nextMode: ->
		})
		Handler = require('handlers.command.nextMode')
	it 'should call modes.nextMode', ->
		Handler()
		assert.spy(_G.modes.nextMode).was_called()