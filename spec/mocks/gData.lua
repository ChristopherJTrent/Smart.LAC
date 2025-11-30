gData = {
	buffCounts = {}
}

gSettings = {}
gProfile = {}
gData.GetPlayer = function()
	return {
		MainJob = PLAYER_MAINJOB,
		MainJobLevel = PLAYER_MAINJOB_LEVEL,
		SubJob = PLAYER_SUBJOB,
		Status = PLAYER_STATUS,
	}
end


function gData.GetAction()
	---@type Action
	return {
		Type = ACTION_TYPE,
		Skill = ACTION_SKILL,
		Name = ACTION_NAME,
		ActionType = ACTION_ACTIONTYPE,
		Id = ACTION_ID
	}
end

gData.GetBuffCount = function(buff)
	if gData.buffCounts[buff] ~= nil then
		return gData.buffCounts[buff]
	end
	return 0
end