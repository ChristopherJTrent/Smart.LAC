---@alias jobHandlers table<string, jobHandler>
---@type jobHandlers
return T{
		COR = gFunc.LoadFile('smart.lac/handlers/JOB/COR.lua'),
		GEO = gFunc.LoadFile('smart.lac/handlers/JOB/GEO.lua'),
		SCH = gFunc.LoadFile('smart.lac/handlers/JOB/SCH.lua'),
		RDM = gFunc.LoadFile('smart.lac/handlers/JOB/RDM.lua'),
		NIN = gFunc.LoadFile('smart.lac/handlers/JOB/NIN.lua'),
		BRD = gFunc.LoadFile('smart.lac/handlers/JOB/BRD.lua'),
		PLD = gFunc.LoadFile('smart.lac/handlers/JOB/PLD.lua'),
		WHM = gFunc.LoadFile('smart.lac/handlers/JOB/WHM.lua'),
		RUN = gFunc.LoadFile('smart.lac/handlers/JOB/RUN.lua'),
		DNC = gFunc.LoadFile('smart.lac/handlers/JOB/DNC.lua')
	}
end)()