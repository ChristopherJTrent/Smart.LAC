return function(args)
	if #args ~= 1 then
		print(Helpers.AddModHeader(chat.error('setWeaponGroup requires exactly 1 argument')))
	else
		modes.setActiveWeaponGroup(args[1])
	end
end