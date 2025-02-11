ashita = {}
ashita.events = {}
ashita.events.register = function(a, b, c) end
chat = T{
	colors = T{
		LawnGreen = "[LG]",
		Reset = "[RS]"
	},
	success = function(string)
		return "success"..string
	end,
	warning = function(string)
		return "warning"..string
	end,
	error = function(string)
		return "error"..string
	end
}