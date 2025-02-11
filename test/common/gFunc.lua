gFunc = {}

local function fileExists(path)
	local f = io.open(path, 'r+')
	if f~= nil then
		io.close(f)
		return true
	else 
		return false
	end
end

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

gFunc.LoadFile = function(path)
	local sep = package.config:sub(1, 1)
	local frameworkRoot = string.gsub(arg[0], string.format("%stests.lua", sep), "")
	path = string.gsub(path, "smart.lac/", '')
	local paths = T{
		path,
		string.format('%s.lua', path),
		string.format("%s%stest%sshared%s%s", frameworkRoot, sep, sep, sep, path),
		string.format("%s%stest%sshared%s%s.lua", frameworkRoot, sep, sep, sep, path),
		string.format("%s%s%s", frameworkRoot, sep, path),
		string.format("%s%s%s.lua", frameworkRoot, sep, path),
	}

	for token in string.gmatch(package.path, "[^;]+") do
        paths:append(string.gsub(token, '?', path));
    end

	local filePath
	for _, _path in ipairs(paths) do
		print(_path)
		if fileExists(_path) then
			filePath = _path
			break
		end
	end

	if filePath == nil then
		error("Attempted to load file that does not exist.")
	end
	print(filePath)
	local func, loadError = loadfile(filePath)
	if not func then
		error('Attempted to load a file that isn\'t lua code')
	end

	local fileValue = nil
	local success, execError = pcall(function()
		fileValue = func()
	end)

	if not success then
		print(execError)
		error('failed to execute file.')
	end

	return fileValue
end