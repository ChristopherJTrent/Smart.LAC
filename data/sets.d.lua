---@meta

---@alias nodeTarget 'Player' | 'Pet' | 'Target' | 'Environment'
---@alias conditionType 'OR' | 'AND'

---@class settings
---@field allowElementalAccessories boolean?

---@class conditionNode
---@field dataField string
---@field dataValue string | number | boolean
---@field targetOverride nodeTarget?
---@field negateCondition boolean?

---@class conditions
---@field nodes conditionNode[]
---@field defaultTarget nodeTarget
---@field conditionType conditionType

---@class equipmentObj
---@field Name string
---@field Augment string[]?
---@field AugPath ("A" | "B" | "C" | "D")?

---@class set
---@field Main equipment?
---@field Sub equipment?
---@field Ammo equipment?
---@field Head equipment?
---@field Neck equipment?
---@field Ear1 equipment?
---@field Ear2 equipment?
---@field Body equipment?
---@field Hands equipment?
---@field Ring1 equipment?
---@field Ring2 equipment?
---@field Back equipment?
---@field Waist equipment?
---@field Legs equipment?
---@field Feet equipment?
---@field condition conditions?

---@alias setNode (set | table<string, setNode>)
---@alias sets table<string, setNode | settings>
---@alias equipment string | equipmentObj