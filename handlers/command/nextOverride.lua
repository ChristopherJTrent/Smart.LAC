return function(args)
	if #args ~= 1 then 
		print(Helpers.AddModHeader(chat.error('nextOverride requires a layer index')))
	else
		modes.nextOverrideState(args[1])
	end
end