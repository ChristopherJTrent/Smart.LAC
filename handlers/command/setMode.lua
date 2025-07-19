return function(args)			
	if #args ~= 1 then
		print(Helpers.AddModHeader("setMode requires exactly 1 argument."))
	else
		modes.setActiveMode(args[1])
	end
end