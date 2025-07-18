return function(args)
	if #args ~= 2 then
		print(Helpers.AddModHeader(chat.error('setWeaponGroup requires exactly 1 argument')))
	else
		modes.setActiveWeaponGroup(args[2])
	end
end