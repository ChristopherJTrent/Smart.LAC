gData = {
	buffCounts = {}
}

gData.GetPlayer = function()
	return {
		MainJob = PLAYER_MAINJOB,
		SubJob = PLAYER_SUBJOB,
		Status = PLAYER_STATUS,

	}
end

gData.GetBuffCount = function(buff)
	if gData.buffCounts[buff] ~= nil then
		return gData.buffCounts[buff]
	end
	return 0
end