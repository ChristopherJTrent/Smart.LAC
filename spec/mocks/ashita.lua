-- local lu = require('luaunit')
ashita = {}
ashita.events = {}
ashita.events.register = function(a, b, c) end
chat = T{
	colors = T{
		LawnGreen = "[LG]",
		Reset = "[RS]",
		SpringGreen = "[SG]"
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
AshitaCore = {}
---@class ExpectedChatCommands
---@field mode integer
---@field command string
AshitaCore.ExpectedChatCommands = T{}
function AshitaCore:GetChatManager()
	local ChatManager = {}
	function ChatManager:QueueCommand(mode, command)
		for i, v in ipairs(AshitaCore.ExpectedChatCommands) do
			if v.mode == mode and v.command == command then
				table.remove(AshitaCore.ExpectedChatCommands, i)
				return
			end
		end
	end
	return ChatManager
end

function AshitaCore:GetInstallPath()
	local p = os.getenv('PWD')
	if p == nil then
		error('These tests will not function on windows. please run the tests again using WSL2 or a linux computer.', 3)
	end
	return p
end