--this is a known valid index.lua, user index.luas will be validated against it.
---@class PlayerData
Index = {
	---@type table<string, boolean>
	ownedBelts = T{
		['Flame Belt']   = false,
		['Soil Belt']    = false,
		['Aqua Belt']    = false,
		['Breeze Belt']  = false,
		['Snow Belt']    = false,
		['Thunder Belt'] = false,
		['Light Belt']   = false,
		['Shadow Belt']  = false,
		['Fotia Belt']   = false
	},
	---@type table<string, boolean>
	ownedGorgets = T{
		['Flame Gorget']   = false,
		['Soil Gorget']    = false,
		['Aqua Gorget']    = false,
		['Breeze Gorget']  = false,
		['Snow Gorget']    = false,
		['Thunder Gorget'] = false,
		['Light Gorget']   = false,
		['Shadow Gorget']  = false,
		['Fotia Gorget']   = false
	},
	---@type boolean
	DisableWeaponWarning = false,
  ---@type boolean
  EnableModeWindow = false,
}

function Index:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

return Index