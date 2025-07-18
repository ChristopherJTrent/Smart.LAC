return function()
	local subjob = gData.GetPlayer().SubJob
	AshitaCore:GetChatManager():QueueCommand(-1, "/tc palette change \""..subjob.." JAs\"")
end