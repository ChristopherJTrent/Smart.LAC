return function(args)			
	if #args ~= 2 then
		print(helpers.AddModHeader("setMode requires exactly 1 argument."))
	else
		modes.setActiveMode(args[2])
	end
end