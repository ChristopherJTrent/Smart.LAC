return function()
	if #args ~= 2 then 
		print(Helpers.AddModHeader(chat.error('nextOverride requires a layer index')))
	else
		modes.nextOverrideState(args[2])
	end
end