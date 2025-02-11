
TestSuite = {}
local lu = require('luaunit')
require('test.common')

require('test.JobHandlers.jobHandlers')

os.exit(lu.LuaUnit.run())