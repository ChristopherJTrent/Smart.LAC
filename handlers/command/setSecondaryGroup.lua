return function(args)
	if #args ~= 2 then
		print(Helpers.AddModHeader(chat.error('setSecondaryGroup requires exactly 1 argument.')))
	else
		modes.setActiveSecondaryGroup(args[2])
	end
end