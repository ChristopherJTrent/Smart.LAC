return function(args)
	if #args ~= 1 then
		print(Helpers.AddModHeader(chat.error('setSecondaryGroup requires exactly 1 argument.')))
	else
		modes.setActiveSecondaryGroup(args[1])
	end
end