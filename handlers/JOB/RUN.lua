---@type jobHandler
return {
    midcast = function (action, sets)
        if sets.midcast == nil then return false end
        if sets.midcast.enmity ~= nil then
            local enmitySpells = T{
                "Flash",
                "Foil",
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
        if sets.midcast.phalanx ~= nil and action.Name == "Phalanx" then
            return sets.midcast.phalanx
        end
        return false
    end,
    ability = function (action, sets)
        if sets.ability == nil then return false end
        if sets.ability.enmity ~= nil then
            local enmityJAs = T{
                "Vallation",
                "Swordplay",
                "Pflug",
                "Valiance",
                "Embolden",
                "Gambit",
                "Rayke",
                "Battuta",
                "Liement",
                "One for All",
                "Odyllic Subterfuge"
            }
            if enmityJAs:contains(action.Name) then
                return sets.ability.enmity
            end
        end
        return false
    end
}