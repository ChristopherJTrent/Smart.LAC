local helpers = gFunc.LoadFile('smart.lac/helpers')

local commands = T{
	cache = T{}
}

function commands:call(name, args) 
	if self.cache.hasKey(name) then
		self.cache[name](args)
	elseif smartFileExists("handlers/command/"..name) then
		self.cache[name] = gFunc.LoadFile("handlers/command/"..name)
		self.cache[name](args)
	else
		print(helpers.AddModHeader(chat.error("Cound not find command "..name..". Check your spelling and note that command names are case-sensitive.")))
	end
end

return function(args)
	commands:call(args[1], args:slice(2, 999))
end