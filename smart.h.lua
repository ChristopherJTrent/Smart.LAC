---@meta

---@alias void nil

---@alias smart fun(sets:sets):smartProfile

---@class SpecializedHandlerContainer
---@field MainJobHandlers table<string, function> | nil
---@field SubJobHandlers table<string, function> | nil

---@class smartProfile
---@field Sets sets
---@field Packer table
---@field OnLoad function
---@field OnUnload function
---@field HandleCommand function
---@field HandleDefault function
---@field HandleAbility function
---@field HandleItem function
---@field HandlePrecast function
---@field HandleMidcast function
---@field HandlePreshot function
---@field HandleMidshot function
---@field HandleWeaponskill function
---@field SpecializedHandlers table<string, function> | nil
---@field withPacker fun(self:table, packerData:table):smartProfile
