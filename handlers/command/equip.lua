return function(args)
	local sets = modes.getSets()
	local switch = {
		function(_) print("equip requries at least 2 arguments") end,
		function(a)
			gFunc.LockSet(sets[a[1]][a[2]], 15)
		end,
		function(a)
			gFunc.LockSet(sets[a[1]][a[2]][a[3]], 15)
		end,
		function(a)
			gFunc.LockSet(sets[a[1]][a[2]][a[3]][a[4]])
		end,
		function(a)
			gFunc.LockSet(sets[a[1]][a[2]][a[3]][a[4]][a[5]])
		end,
	}
	switch[#args](args)
end