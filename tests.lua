
TestSuite = {}
TESTING_MODE = function() end
local lu = require('luaunit')
---@diagnostic disable-next-line: different-requires
require('test.common')

require('test.JobHandlers.jobHandlers')

os.exit(lu.LuaUnit.run())