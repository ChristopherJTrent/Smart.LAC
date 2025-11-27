-- local lu = require('luaunit')

FORCE_LOAD_FAILURES = T{}
LOADFILE_REPLACE_CONTENT = T{}

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
	if FORCE_LOAD_FAILURES:hasval(path) then
		return nil
	end
	if T(LOADFILE_REPLACE_CONTENT):haskey(path) then 
		return LOADFILE_REPLACE_CONTENT[path]
	end
	local sep = package.config:sub(1, 1)
	local frameworkRoot = os.getenv('PWD')
	if frameworkRoot == nil then
		error('These tests will not function on windows. please run the tests again using WSL2 or a linux computer.', 3)
	end
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
		if fileExists(_path) then
			filePath = _path
			break
		end
	end

	if filePath == nil then
		error("Attempted to load file that does not exist.")
	end
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

gFunc.EquipSet = function(set)
	if EXPECTED_SET ~= nil then
	end
end

gFunc.LockSet = function(set, _)
	if EXPECTED_SET ~= nil then
	end
end