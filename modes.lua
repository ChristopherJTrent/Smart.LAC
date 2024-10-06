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

modeTable.weaponsEnabled = false
modeTable.weaponGroups = {}
modeTable.weaponGroupList = {}
modeTable.currentWeaponGroup = 1

local getCurrentMode = function()
  return modeTable.modeList[modeTable.currentMode]
end

local getCurrentWeaponGroup = function()
  return modeTable.weaponGroupList[modeTable.currentWeaponGroup]
end

return {
  enableWeaponGroups = function()
    print(helpers.AddModHeader(chat.success('Enabled weapon groups')))
    modeTable.weaponsEnabled = true
  end,
  registerSets = function (mode, sets)
    if modeTable.modes[mode] == nil then
      modeTable.modes[mode] = sets
      modeTable.modeList[#modeTable.modeList + 1] = mode
    end
  end,
  registerWeaponGroup = function(group, set)
    if modeTable.weaponGroups[group] == nil then
      modeTable.weaponGroups[group] = set
      modeTable.weaponGroupList[#modeTable.weaponGroupList + 1] = group
    end
  end,
  getSets = function()
    return modeTable.modes[getCurrentMode()]
  end,
  getWeaponGroup = function()
    return modeTable.weaponGroups[getCurrentWeaponGroup()]
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
  setActiveWeaponGroup = function(key)
    if not modeTable.weaponsEnabled then
      print(helpers.AddModHeader(chat.error('Weapon Groups are not enabled.')))
      return
    end
    if modeTable.weaponGroups[key] ~= nil then
      for i, v in pairs(modeTable.weaponGroupList) do
        if v == key then
          modeTable.currentWeaponGroup = i
          break
        end
      end
    else
      print(helpers.AddModHeader("Could not set weapon group "..key.." because that group isn't registered."))
    end
  end,
  nextMode = function()
    if #modeTable.modeList == modeTable.currentMode then
      modeTable.currentMode = 1
    else
      modeTable.currentMode = modeTable.currentMode + 1
    end
  end,
  nextWeaponGroup = function()
    if #modeTable.weaponGroupList == modeTable.currentWeaponGroup then
      modeTable.currentWeaponGroup = 1
    else
      modeTable.currentWeaponGroup = modeTable.currentWeaponGroup + 1
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
          if modeTable.weaponsEnabled then
            imgui.Text('Current Weapon Set: ')
            imgui.SameLine()
            imgui.Text(getCurrentWeaponGroup() or 'None')
          end
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