---@diagnostic disable: different-requires
if TESTING_MODE ~= nil then
	require('test.common')
else
	require('common')
end