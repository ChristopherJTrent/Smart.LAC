---@alias jobHandlers table<string, jobHandler>
---@type jobHandlers
return (function()
	return T{
		COR = gFunc.LoadFile('smart.lac/handlers/JOB/COR.lua'),
		GEO = gFunc.LoadFile('smart.lac/handlers/JOB/GEO.lua'),
		SCH = gFunc.LoadFile('smart.lac/handlers/JOB/SCH.lua'),
		RDM = gFunc.LoadFile('smart.lac/handlers/JOB/RDM.lua')
	}
end)()