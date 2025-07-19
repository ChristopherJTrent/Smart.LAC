return function(args) 
	if #args ~= 2 then
		print(Helpers.AddModHeader("setWindowLocation requires exactly 3 arguments"))
	elseif string.lower(args[1]) == 'x' then
		modes.setWindowPosX(tonumber(args[2]) or ModeTable.imgui.windowPosX)
	elseif string.lower(args[1]) == 'y' then
		modes.setWindowPosY(tonumber(args[2]) or ModeTable.imgui.windowPosY)
	else 
		print(Helpers.AddModHeader("second argument must be either x or y"))
	end
end