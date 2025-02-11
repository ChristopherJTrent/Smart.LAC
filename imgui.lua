-- !!! This file is for testing purposes only.
if TESTING_MODE ~= nil then
	ImGuiWindowFlags_NoDecoration = 1
	ImGuiWindowFlags_AlwaysAutoResize = 2
	ImGuiWindowFlags_NoSavedSettings = 4
	ImGuiWindowFlags_NoFocusOnAppearing = 8
	ImGuiWindowFlags_NoNav = 16
	return {
		SetNextWindowBgAlpha = function(i) end,
		SetNextWindowSize = function(a, b) end,
		SetNextWindowSizeConstraints = function(a, b) end,
		SetNextWindowPos = function(a) end,
		Begin = function(a, b, c) end
	}
else
	return dofile(string.format('%saddons\\libs\\imgui.lua',AshitaCore:GetInstallPath()))
end