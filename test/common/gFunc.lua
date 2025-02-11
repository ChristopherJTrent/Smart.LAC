gFunc = {}

gFunc.Combine = function(base, override)
	local newSet = {}

	for key, val in pairs(base) do
		if type(key) == "string" then
			newSet[key] = val
		end
	end
	for key, val in pairs(override) do
		if type(key) == "string" then
			newSet[key] = val
		end
	end
	return newSet
end