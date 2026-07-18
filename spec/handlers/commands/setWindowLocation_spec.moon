describe 'setWindowLocation command', ->
	local Handler
	setup ->
		_G.Helpers = mock({AddModHeader: (s) -> s})
		_G.modes = mock({
			setWindowPosX: (n) -> n
			setWindowPosY: (n) -> n
		}, true)
		_G.ModeTable = {
			imgui: {
				windowPosX: 0
				windowPosY: 0
			}
		}
		stub(_G, 'print')
		Handler = require('handlers.command.setWindowLocation')
	context 'when passed the incorrect number of arguments', ->
		it 'should print an error message to chat', ->
			Handler({})
			Handler({'a'})
			Handler({'a', 'a', 'a'})
			assert.stub(_G.print).was_called(3)
	context 'when passed anything other than x or y as the first argument', ->
		it 'should print an error message to chat', ->
			Handler({'a', 'a'})
			assert.stub(_G.print).was_called()
	
	context 'when passed x as the first argument', ->
		context 'and a string representing a number as the second', ->
			it 'should call modes.setWindowPosX with that number', ->
				Handler({'x', '1'})
				assert.stub(_G.modes.setWindowPosX).was_called_with(1)
		context 'and a string not representing a number as the second', ->
			it 'should call modes.setWindowPosX with the current value of ModeTable.imgui.windowPosX', ->
				Handler({'x', 'foo'})
				assert.stub(_G.modes.setWindowPosX).was_called_with(_G.ModeTable.imgui.windowPosX)

	context 'when passed y as the first argument', ->
		context 'and a string representing a number as the second', ->
			it 'should call modes.setWindowPosY with that number', ->
				Handler({'y', '1'})
				assert.stub(_G.modes.setWindowPosY).was_called_with(1)
		context 'and a string that does not represent a number as the second', ->
			it 'should call modes.setWindowPosY with the current value of ModeTable.imgui.windowPosY', ->
				Handler({'y', 'foo'})
				assert.stub(_G.modes.setWindowPosY).was_called_with(_G.ModeTable.imgui.windowPosY)
