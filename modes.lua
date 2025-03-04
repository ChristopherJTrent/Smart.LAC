--luacheck: globals require modeTable print ashita bit

require('common')
local imgui = require('imgui')
local helpers = gFunc.LoadFile('smart.lac/helpers.lua')
local index = gFunc.LoadFile('index.lua')
local globals = gFunc.LoadFile('globals.lua')

if not imgui or not helpers or not index or not globals then return nil end

local defaultBindings = {
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "0",
  "+1",
  "+2",
  "+3",
  "+4",
  "+5",
  "+6",
  "+7",
  "+8",
  "+9",
  "+0",
}
local defaultWeaponBindings = T{
  "^1",
  "^2",
  "^3",
  "^4",
  "^5",
  "^6",
  "^7",
  "^8",
  "^9",
  "^0",
  "^+1",
  "^+2",
  "^+3",
  "^+4",
  "^+5",
  "^+6",
  "^+7",
  "^+8",
  "^+9",
  "^+0",
}
local defaultSecondaryBindings = T{
  "!1",
  "!2",
  "!3",
  "!4",
  "!5",
  "!6",
  "!7",
  "!8",
  "!9",
  "!0",
  "!+1",
  "!+2",
  "!+3",
  "!+4",
  "!+5",
  "!+6",
  "!+7",
  "!+8",
  "!+9",
  "!+0",
}

ModeTable = {}
ModeTable.enableWindow = true
ModeTable.imgui = {}
if index.imgui then
  if index.imgui.posX then
    ModeTable.imgui.windowPosX = index.imgui.posX
  else 
    ModeTable.imgui.windowPosX = 3200
  end
  if index.imgui.posY then
    ModeTable.imgui.windowPosY = index.imgui.posY
  else 
    ModeTable.imgui.windowPosY = 750
  end
else 
  ModeTable.imgui.windowPosX = 3200
  ModeTable.imgui.windowPosY = 750
end

ModeTable.modeList = {}
ModeTable.currentMode = 1
ModeTable.modes = {}

ModeTable.weaponsEnabled = false
ModeTable.weaponGroups = {}
ModeTable.weaponGroupList = {}
ModeTable.currentWeaponGroup = 1

ModeTable.secondaryEnabled = false
ModeTable.secondaryGroups = {}
ModeTable.secondaryGroupList = {}
ModeTable.currentSecondaryGroup = 1

ModeTable.overrideLayersEnabled = false
ModeTable.overrideLayers = T{}
ModeTable.overrideLayerStates = T{}
ModeTable.overrideLayerNames = T{}
ModeTable.overrideStateNames = T{}
ModeTable.keybinds = T{}

local getCurrentMode = function()
  return ModeTable.modeList[ModeTable.currentMode]
end

local getCurrentWeaponGroup = function()
  return ModeTable.weaponGroupList[ModeTable.currentWeaponGroup]
end

local getCurrentSecondaryGroup = function()
  return ModeTable.secondaryGroupList[ModeTable.currentSecondaryGroup]
end

return {
  generatePackerConfig = function()
    local builder = gFunc.LoadFile('smart.lac/packerBuilder.lua')
    if not builder then 
      print(helpers.AddModHeader(chat.error("Failed to load builder lib")))
      return 
    end
    builder:process(ModeTable.modes)
    builder:process(ModeTable.weaponGroups)
    builder:process(ModeTable.secondaryGroups)
    builder:process(ModeTable.overrideLayers)
    return builder:get()
  end,
  registerKeybinds = function()
    local chatManager = AshitaCore:GetChatManager()
    chatManager:QueueCommand(-1, "/unbind all");
    (function()
      chatManager:QueueCommand(-1, "/bind F12 /lac fwd nextMode")
      chatManager:QueueCommand(-1, "/bind F11 /lac fwd nextWeaponGroup")
      chatManager:QueueCommand(-1, "/bind F10 /lac fwd nextSecondaryGroup")
      for i, v in ipairs(ModeTable.keybinds) do
        chatManager:QueueCommand(-1, "/bind "..v.." /lac fwd nextOverride "..i)
      end
      for i, _ in ipairs(ModeTable.weaponGroups) do
        chatManager:QueueCommand(-1, "/bind "..defaultWeaponBindings[i].." /lac fwd setActiveWeaponGroup "..i)
      end
      for i, _ in ipairs(ModeTable.secondaryGroups) do
        chatManager:QueueCommand(-1, "/bind "..defaultSecondaryBindings[i].." /lac fwd setActiveSecondaryGroup "..i)
      end
      -- function:once is defined by the ashita SDK.
      ---@diagnostic disable-next-line: undefined-field
    end):once(0.25)
  end,
  enableWeaponGroups = function()
    if globals.debug then 
      print(helpers.AddModHeader(chat.success('Enabled weapon groups')))
    end
    ModeTable.weaponsEnabled = true
  end,
  enableSecondaryGroups = function()
    if globals.debug then 
      print(helpers.AddModHeader(chat.success('Enabled secondary weapon groups')))
    end
    ModeTable.secondaryEnabled = true
  end,
  enableOverrideLayers = function()
    if globals.debug then 
      print(helpers.AddModHeader(chat.success('Enabled override layers')))
    end
    ModeTable.overrideLayersEnabled = true
  end,
  registerSets = function (mode, sets)
    if ModeTable.modes[mode] == nil then
      ModeTable.modes[mode] = sets
      ModeTable.modeList[#ModeTable.modeList + 1] = mode
    end
  end,
  registerWeaponGroup = function(group, set)
    if ModeTable.weaponGroups[group] == nil then
      ModeTable.weaponGroups[group] = set
      ModeTable.weaponGroupList[#ModeTable.weaponGroupList + 1] = group
    end
  end,
  registerSecondaryGroup = function(group, set)
    if ModeTable.secondaryGroups[group] == nil then
      ModeTable.secondaryGroups[group] = set
      ModeTable.secondaryGroupList[#ModeTable.secondaryGroupList + 1] = group
    end
  end,
  registerOverride = function(layerName, sets, stateName, keybind)
    local foundIndex = ModeTable.overrideLayerNames:find(layerName)
    if foundIndex then
      if not stateName then
        print(helpers.AddModHeader(chat.error('Cannot add additional states to an existing override layer without supplying a state name.')))
        return
      end
      local layerSize = #ModeTable.overrideLayers[foundIndex]
      ModeTable.overrideLayers[foundIndex][layerSize + 1] = sets
      ModeTable.overrideStateNames[foundIndex][#ModeTable.overrideStateNames[foundIndex] + 1] = stateName
    else
      local nextIdx = #ModeTable.overrideLayerNames + 1
      ModeTable.overrideLayers[nextIdx] = {{}, sets}
      ModeTable.overrideLayerNames[nextIdx] = layerName
      ModeTable.overrideStateNames[nextIdx] = T{"OFF"}
      ModeTable.overrideLayerStates[nextIdx] = 1
      if stateName then
        ModeTable.overrideStateNames[nextIdx][2] = stateName
      else
        ModeTable.overrideStateNames[nextIdx][2] = "ON"
      end
      if keybind then
        ModeTable.keybinds[nextIdx] = keybind
      else
        ModeTable.keybinds[nextIdx] = defaultBindings[nextIdx]
      end
    end
  end,
  applyOverrides = function(baseSet, outerKey, innerKey, secondaryInnerKey)
    if not ModeTable.overrideLayersEnabled then return baseSet end
    local outputSet = baseSet
    for _, v in ipairs({ModeTable.weaponGroups[getCurrentWeaponGroup()].overrides, ModeTable.secondaryGroups[getCurrentSecondaryGroup()].overrides}) do
      if v ~= nil then
        if v[outerKey] ~= nil then
          if v[outerKey][innerKey] ~= nil then
            if v[outerKey][innerKey][secondaryInnerKey] ~= nil then
              outputSet = gFunc.Combine(outputSet, v[outerKey][innerKey][secondaryInnerKey])
            else
              outputSet = gFunc.Combine(outputSet, v[outerKey][innerKey])
            end
          end
        end
      end
    end
    for i, v in ipairs(ModeTable.overrideLayers) do
      local layerState = ModeTable.overrideLayerStates[i]
      if v[layerState][outerKey] ~= nil then
        if innerKey ~= nil and v[layerState][outerKey][innerKey] ~= nil then
          if secondaryInnerKey ~= nil and v[layerState][outerKey][innerKey][secondaryInnerKey] ~= nil then
            -- will generally only be true if you're using the buff handler
            outputSet = gFunc.Combine(outputSet, v[layerState][outerKey][innerKey][secondaryInnerKey])
          else            
            outputSet = gFunc.Combine(outputSet, v[layerState][outerKey][innerKey])
          end
        end
      end
    end
    return outputSet
  end,
  getSets = function()
    return ModeTable.modes[getCurrentMode()]
  end,
  getWeaponGroup = function()
    local current = ModeTable.weaponGroups[getCurrentWeaponGroup()]
    return {
      Main = current.Main,
      Sub = current.Sub,
      Range = current.Range,
      Ammo = current.Ammo
    }
  end,
  getSecondaryGroup = function()
    local current = ModeTable.secondaryGroups[getCurrentSecondaryGroup()]
    return {
      Main = current.Main,
      Sub = current.Sub,
      Range = current.Range,
      Ammo = current.Ammo
    }
  end,
  setActiveMode = function(key)
    local index = tonumber(key)
    if index ~= nil then
      if index > #ModeTable.modeList then
        print(helpers.AddModHeader(chat.error('Mode index out of bounds.')))
      else
        ModeTable.currentMode = index
      end
    elseif ModeTable.modes[key] ~= nil then
      for i, v in pairs(ModeTable.modeList) do
        if v == key then
          ModeTable.currentMode = i
          break
        end
      end
    else
      print(helpers.AddModHeader("Could not set mode "..key.." because that mode isn't registered."))
    end
  end,
  setActiveWeaponGroup = function(key)
    if not ModeTable.weaponsEnabled then
      print(helpers.AddModHeader(chat.error('Weapon Groups are not enabled.')))
      return
    end
    local index = tonumber(key)
    if index ~= nil then
      ModeTable.currentWeaponGroup = index
    elseif ModeTable.weaponGroups[key] ~= nil then
      for i, v in pairs(ModeTable.weaponGroupList) do
        if v == key then
          ModeTable.currentWeaponGroup = i
          break
        end
      end
    else
      print(helpers.AddModHeader("Could not set weapon group "..key.." because that group isn't registered."))
    end
  end,
  setActiveSecondaryGroup = function(key)
    if not ModeTable.secondaryEnabled then
      print(helpers.AddModHeader(chat.error('Secondary Weapon Groups are not enabled.')))
      return
    end    local index = tonumber(key)
    if index ~= nil then
      ModeTable.currentSecondaryGroup = index
    elseif ModeTable.secondaryGroups[key] ~= nil then
      for i, v in pairs(ModeTable.secondaryGroupList) do
        if v == key then
          ModeTable.currentSecondaryGroup = i
          break
        end
      end
    else
      print(helpers.AddModHeader("Could not set secondary weapon group "..key.." because that group isn't registered."))
    end
  end,
  nextMode = function()
    if #ModeTable.modeList == ModeTable.currentMode then
      ModeTable.currentMode = 1
    else
      ModeTable.currentMode = ModeTable.currentMode + 1
    end
  end,
  nextWeaponGroup = function()
    if #ModeTable.weaponGroupList == ModeTable.currentWeaponGroup then
      ModeTable.currentWeaponGroup = 1
    else
      ModeTable.currentWeaponGroup = ModeTable.currentWeaponGroup + 1
    end
  end,
  nextOverrideState = function(layer)
    local l = tonumber(layer)
    if l == nil then
      l = ModeTable.overrideStateNames:find(layer)
    end
    if #ModeTable.overrideLayers[l] == ModeTable.overrideLayerStates[l] then
      ModeTable.overrideLayerStates[l] = 1
    else
      ModeTable.overrideLayerStates[l] = ModeTable.overrideLayerStates[l] + 1
    end
  end,
  nextSecondaryGroup = function()
    if #ModeTable.secondaryGroupList == ModeTable.currentSecondaryGroup then
      ModeTable.currentSecondaryGroup = 1
    else
      ModeTable.currentSecondaryGroup = ModeTable.currentSecondaryGroup + 1
    end
  end,
  setWindowPosX = function(x)
    ModeTable.imgui.windowPosX = x
  end,
  setWindowPosY = function(y)
    ModeTable.imgui.windowPosY = y
  end,
  initializeWindow = function()
    local red = {0.91, 0.323, 0.091, 1}
    local green = {0.091, 0.91, 0.105, 1}
    local blue = {0.446, 0.516, 0.970, 1}
    local beige = {0.839, 0.827, 0.729, 1}
    ashita.events.register('d3d_present', 'present_cb', function()
      if ModeTable and ModeTable.enableWindow then
        local flags = bit.bor(
          ImGuiWindowFlags_NoDecoration,
          ImGuiWindowFlags_AlwaysAutoResize,
          ImGuiWindowFlags_NoSavedSettings,
          ImGuiWindowFlags_NoFocusOnAppearing,
          ImGuiWindowFlags_NoNav
        )
        imgui.SetNextWindowBgAlpha(0.8)
        imgui.SetNextWindowSize({-1, -1}, ImGuiCond_Always)
        imgui.SetNextWindowSizeConstraints({-1, -1}, {FLT_MAX, FLT_MAX})
        imgui.SetNextWindowPos({ModeTable.imgui.windowPosX, ModeTable.imgui.windowPosY}, ImGuiCond_Always, {0, 0})
        if (imgui.Begin('smart.lac', true, flags)) then
          local showSeparator = false
          imgui.SetWindowFontScale(1)
          imgui.Text("Smart.LAC")
          imgui.Separator()
          if ModeTable.secondaryEnabled then 
            showSeparator = true
            imgui.TextColored(red, '(F10)')
            imgui.SameLine()
            imgui.Text('Secondary:')
            imgui.SameLine()
            imgui.TextColored(beige, getCurrentSecondaryGroup() or 'None')
          end
          if ModeTable.weaponsEnabled then
            showSeparator = true
            imgui.TextColored(red, '(F11)')
            imgui.SameLine()
            imgui.Text('Weapon:')
            imgui.SameLine()
            imgui.TextColored(beige, getCurrentWeaponGroup() or 'None')
          end
          if #ModeTable.modeList > 1 then
            showSeparator = true
            imgui.TextColored(red, '(F12)')
            imgui.SameLine()
            imgui.Text('Mode:')
            imgui.SameLine()
            imgui.TextColored(beige, getCurrentMode() or 'None')  
          end
          if ModeTable.overrideLayersEnabled then
            if showSeparator then imgui.Separator() end
            for i, v in ipairs(ModeTable.overrideLayers) do
              imgui.TextColored(red, "("..ModeTable.keybinds[i]..")")
              imgui.SameLine()
              imgui.Text(ModeTable.overrideLayerNames[i]..":")
              imgui.SameLine()
              local state = ModeTable.overrideStateNames[i][ModeTable.overrideLayerStates[i]]
              if state == "OFF" then
                imgui.TextColored(red, state)
              elseif state == "ON" then
                imgui.TextColored(green, state)
              else
                imgui.Text(state)
              end
            end
          end
          imgui.End()
        end
      end
    end)
  end,
  setWindowVisibility = function(b)
    ModeTable.enableWindow = b
  end,
  toggleWindowVisibility = function()
    ModeTable.enableWindow = not ModeTable.enableWindow
  end
}