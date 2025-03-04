---- Setup Globals
gFunc.LoadFile('smart.lac/modes/constraints.lua')
---- end Setup Globals

---@alias ItemTable {Name: string, AugPath: string?, Augment: string[]?}

---@alias Weapon {Item: string | ItemTable, Constraints: function[] | nil}

---@class Weapons
---@field Current integer
---@field Defs {[integer] : Weapon}

Modes = {
	-- setting this field to true will change the library's behavior and allow the use of the Main, Sub, and Range fields in set tables
	-- Enabling this and adding weapons to your sets will cause you to blink and lose TP.
	SetWeaponsTakePrecedence = false,
	-- Setting this field to true will disable the guardrails that prevent you from
	-- equipping the same weapon in both the Main and Sub slots.
	AllowDuplicateWeapons = false,
	---@type Weapons
	Mainhands = T{
		Current = nil,
		Defs = T{}
	},
	---@type Weapons
	Offhands = T{
		Current = nil,
		Defs = T{}
	},
	---@type Weapons
	Ranged = T{
		Current = nil,
		Defs = T{}
	},
}

---@param weapon Weapon
---@param kind "Mainhands"|"Offhands"|"Ranged"
function Modes:RegisterWeapon(weapon, kind)
	self[kind].Defs:append(weapon)
end

---@private
---@param from integer?
---@return Error?, integer?
---@nodiscard
function Modes:GetNextValidMainhand(from)
	local start = from or self.Mainhands.Current
	local i = start + 1
	while i ~= start do
		if i == #self.Mainhands.Defs + 1 then
			i = 1
		elseif self.AllowDuplicateWeapons then
			return nil, i
		elseif T(self.Mainhands.Defs[i].Constraints or {}):all(function(v) return v() end) then
			if self.Offhands.Defs[self.Offhands.Current].Item ~= self.Mainhands.Defs[i].Item then
				return nil, i
			else
				i = i + 1
			end
		else
			i = i + 1
		end
	end
	return {Message = "could not find valid mainhand."}, nil
end

function Modes:NextMainhand()
	local err, nextIndex = self:GetNextValidMainhand()
	if err == nil then ---@cast nextIndex -?
		self.Mainhands.Current = nextIndex
	end
end