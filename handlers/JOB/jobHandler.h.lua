---@alias actionHandler fun(action:Action, sets:sets): boolean
---actionHandler returns true if an action was handled, false otherwise.

---@meta
---@class jobHandler
---@field ability actionHandler
