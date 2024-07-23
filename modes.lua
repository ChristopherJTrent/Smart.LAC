--luacheck: globals require modeTable print ashita bit

require('common')
local imgui = require('imgui')
local helpers = gFunc.LoadFile('smart.lac/helpers.lua')

modeTable = {}
modeTable.enableWindow = true
modeTable.imgui = {}
modeTable.imgui.windowPosX = 1300
modeTable.imgui.windowPosY = 400

modeTable.modeList = {}
modeTable.currentMode = 1

modeTable.modes = {}

local getCurrentMode = function()
  return modeTable.modeList[modeTable.currentMode]
end

return {
  registerSets = function (mode, sets)
    if modeTable.modes[mode] == nil then
      modeTable.modes[mode] = sets
      modeTable.modeList[#modeTable.modeList + 1] = mode
    end
  end,
  getSets = function()
    return modeTable.modes[getCurrentMode()]
  end,
  setActiveMode = function(key)
    if modeTable.modes[key] ~= nil then
      for i, v in pairs(modeTable.modeList) do
        if v == key then
          modeTable.currentMode = i
          break
        end
      end
    else
      print(helpers.AddModHeader("Could not set mode "..key.." because that mode isn't registered."))
    end
  end,
  nextMode = function()
    if #modeTable.modeList == modeTable.currentMode then
      modeTable.currentMode = 1
    else
      modeTable.currentMode = modeTable.currentMode + 1
    end
  end,
  setWindowPosX = function(x)
    modeTable.imgui.windowPosX = x
  end,
  setWindowPosY = function(y)
    modeTable.imgui.windowPosY = y
  end,
  initializeWindow = function()
    ashita.events.register('d3d_present', 'present_cb', function()
      if modeTable and modeTable.enableWindow then
        local flags = bit.bor(
          ImGuiWindowFlags_NoDecoration,
          ImGuiWindowFlags_AlwaysAutoResize,
          ImGuiWindowFlags_NoSavedSettings,
            ImGuiWindowFlags_NoFocusOnAppearing,
            ImGuiWindowFlags_NoNav
        )
        imgui.SetNextWindowBgAlpha(0.8)
        imgui.SetNextWindowSize({300, -1}, ImGuiCond_Always)
        imgui.SetNextWindowSizeConstraints({-1, -1}, {FLT_MAX, FLT_MAX})
        imgui.SetNextWindowPos({modeTable.imgui.windowPosX, modeTable.imgui.windowPosY}, ImGuiCond_Always, {0, 0})
        if (imgui.Begin('smart.lac', true, flags)) then
          imgui.SetWindowFontScale(1)
          imgui.Text("Smart.LAC")
          imgui.Separator()
          imgui.Text('Current Mode: ')
          imgui.SameLine()
          imgui.Text(getCurrentMode() or 'None')
          imgui.End()
        end
      end
    end)
  end,
  setWindowVisibility = function(b)
    modeTable.enableWindow = b
  end,
  toggleWindowVisibility = function()
    modeTable.enableWindow = not modeTable.enableWindow
  end
}