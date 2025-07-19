local commands = T{
	cache = T{}
}

function commands:call(name, args) 
	if self.cache:containskey(name) then
		self.cache[name](args)
	elseif Helpers.SmartFileExists(Helpers.BuildPlatformPath("handlers","command",name)) then
		self.cache[name] = gFunc.LoadFile(Helpers.BuildPlatformPath("Smart.LAC","handlers","command",name..".lua"))
		self.cache[name](args)
	else
		print(Helpers.AddModHeader(chat.error("Cound not find command "..name..". Check your spelling and note that command names are case-sensitive.")))
	end
end

return function(args)
	commands:call(args[1], T(args):slice(2, 999))
end