---@alias jobHandlers table<string, jobHandler>
---@type jobHandlers
return (function()
	return T{
		COR = gFunc.LoadFile('smart.lac/handlers/JOB/COR.lua'),
		GEO = gFunc.LoadFile('smart.lac/handlers/JOB/GEO.lua')
	}
end)()