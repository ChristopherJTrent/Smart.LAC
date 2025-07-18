return function()
	local mainhand = ModeTable.weaponGroups[ModeTable.weaponGroupList[ModeTable.currentWeaponGroup]].Main or ""
	if mainhand ~= "" then
		local skill = SkillNames[AshitaCore:GetResourceManager():GetItemByName(mainhand, 0).Skill]
		AshitaCore:GetChatManager():QueueCommand(-1, "/tc palette change \""..skill.." Weaponskills\"")
	end
end