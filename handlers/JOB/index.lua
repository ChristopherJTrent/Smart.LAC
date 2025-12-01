---@alias jobHandlers table<string, jobHandler>
---@type jobHandlers
return (function()
	local ret = T{
		cache = T{},
	}
	setmetatable(ret, {
		__index = function (t, k)
			if t.cache[k] ~= nil then return t.cache[k] end
			if Helpers.SmartFileExists('handlers.job.'..k) then
				t.cache[k] = gFunc.LoadFile('smart.lac/handlers/JOB/'..k..'.lua')
				return t.cache[k]
			end
			return nil
		end
	})
	return ret
end)()