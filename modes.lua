require('common')
local imgui = require('imgui')
local helpers = gFunc.LoadFile('smart.lac/helpers.lua')

modeTable = {}

modeTable.modes = {}
modeTable.activeMode = ''



return {
  registerSets = function (mode, sets)
    if modeTable.modes[mode] == nil then
      modeTable.modes[mode] = sets
    end
  end,
  getSets = function()
    return modeTable.modes[modeTable.activeMode]
  end,
  setActiveMode = function(key)
    if modeTable.modes[key] ~= nil then
      modeTable.activeMode = key
    else
      print(helpers.AddModHeader("Could not set mode "..key.." because that mode isn't registered."))
    end
  end,
  initializeWindow = function()
    ashita.events.register('d3d_present', 'present_cb', function()
      local flags = bit.bor(
        ImGuiWindowFlags_NoDecoration,
        ImGuiWindowFlags_AlwaysAutoResize,
        ImGuiWindowFlags_NoSavedSettings,
          ImGuiWindowFlags_NoFocusOnAppearing,
          ImGuiWindowFlags_NoNav
      )
      imgui.SetNextWindowBgAlpha(0.8)
      imgui.SetNextWindowSize({200, -1}, ImGuiCond_Always)
      imgui.SetNextWindowSizeConstraints({-1, -1}, {FLT_MAX, FLT_MAX})
      imgui.SetNextWindowPos({1400, 400}, ImGuiCond_Always, {0, 0})
      if (imgui.Begin('smart.lac', true, flags)) then
        imgui.SetWindowFontScale(1)
        imgui.Text("Smart.LAC")
        imgui.Separator()
        imgui.Text('Current Mode: ')
        imgui.SameLine()
        imgui.Text(modeTable.activeMode or 'None')
        imgui.End()
      end
    end)
  end
}