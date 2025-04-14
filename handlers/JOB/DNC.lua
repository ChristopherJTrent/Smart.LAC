---@type jobHandler
return {
    ability = function (action, sets)
        if sets.ability == nil then return false end
        if sets.ability.jigs and string.find(action.Name, " Jig") then
            return gFunc.Combine(sets.ability.default or {}, sets.ability.jigs)
        end
        if sets.ability.steps and string.find(action.Name, " Step") then
            return gFunc.Combine(sets.ability.default or {}, sets.ability.steps)
        end
        if sets.ability.sambas and string.find(action.Name, " Samba") then
            return gFunc.Combine(sets.ability.default or {}, sets.ability.sambas)
        end
        return false
    end
}