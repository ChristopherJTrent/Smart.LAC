---@type jobHandler
return {
    midcast = function(action, sets) 
        if sets.midcast == nil then return false end
        if sets.midcast.enmity ~= nil then
            local enmitySpells = T{
                "Flash",
                "Blank Gaze",
                "Jettatura",
                "Sheep Song",
                "Stinking Gas",
                "Geist Wall",
                "Soporific",
                "Cold Wave"
            }
            if enmitySpells:contains(action.Name) then
                return sets.midcast.enmity
            end
        end
        return false
    end,
    ability = function(action, sets)
        if sets.ability == nil then return false end
        if sets.ability.enmity ~= nil then
            local enmityJAs = T{
                "Shield Bash",
                "Sentinel",
                "Rampart",
                "Palisade",
                "Majesty",
                "Divine Emblem",
                "Fealty",
                "Chivalry",
                "Intervene"
            }
            if enmityJAs:contains(action.Name) then
                return sets.ability.enmity
            end
        end
        return false
    end
}