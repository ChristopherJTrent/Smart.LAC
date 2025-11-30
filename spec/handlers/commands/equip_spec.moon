describe 'equip command', ->
	local modesMock, gFuncMock
	export modes, gFunc
	setup ->
		gFunc = 
			LockSet: => print('')
		gFuncMock = mock(gFunc, true)
		modes = 
			getSets: -> 
				a: 
					a: 
						a: 
							a: 
								a:
		modesMock = mock(modes)

	