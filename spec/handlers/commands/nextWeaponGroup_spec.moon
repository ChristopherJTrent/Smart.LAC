describe 'nextWeaponGroup command', ->
	local Handler
	setup ->
		_G.modes = mock({nextWeaponGroup: ->})
		Handler = require('handlers.command.nextWeaponGroup')
	it 'should call modes.nextWeaponGroup', ->
		Handler()
		assert.spy(_G.modes.nextWeaponGroup).was_called()