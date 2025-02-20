
TestSuite = {}
TESTING_MODE = function() end
local lu = require('luaunit')
require('luacov')
---@diagnostic disable-next-line: different-requires
require('test.common')
require('smart')

require('test.jobHandlers')
require('test.core')

os.exit(lu.LuaUnit.run())