---@diagnostic disable: missing-fields
---@type helpers
local helpers = require('helpers')
local lu = require('luaunit')

TestHelpers = {}

function TestHelpers:testEnsureSugaredTable()
	lu.assertNotNil(helpers.EnsureSugaredTable)
	lu.assertNil(helpers.EnsureSugaredTable(nil))
	lu.assertNotNil(helpers.EnsureSugaredTable({}).contains)
end

function TestHelpers:testContainsAllKeys()
	lu.assertNotNil(helpers.ContainsAllKeys)
	lu.assertTrue(helpers.ContainsAllKeys({a = 1}, {a = 2}))
	lu.assertFalse(helpers.ContainsAllKeys({a = 1}, {b = 2}))
	lu.assertTrue(helpers.ContainsAllKeys({a = 1}, {a = 1, b = 2}))
	lu.assertFalse(helpers.ContainsAllKeys({a = 1, b = 2}, {a = 1}))
end