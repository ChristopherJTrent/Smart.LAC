return {
    midcast = function(action, sets)
        if sets.midcast == nil then return false end
        if action.Skill == "Enfeebling Magic" then
            if sets.midcast['Enfeebling Magic'] == nil or type(sets.midcast['Enfeebling Magic']) ~= type({}) then return false end
            local groups = T{
                highSkill = T{"Distract III", "Frazzle III"},
                lowSkill = T{"Poison", "Poison II"},
                duration = T{"Inundation"},
                mAccDuration = T{"Sleep", "Sleep II", "Bind", "Break", "Silence"},
                mAccPotency = T{"Gravity", "Gravity II"},
                mAcc = T{"Frazzle", "Frazzle II", "Dispel", "Distract", "Distract II"},
                MND = T{"Paralyze", "Paralyze II", "Addle", "Addle II", "Slow", "Slow II"},
                INT = T{"Blind", "Blind II"}
            }

            for group, spells in ipairs(groups) do
                if sets.midcast['Enfeebling Magic'][group] ~= nil and spells.include(action.Name) then
                    return sets.midcast['Enfeebling Magic'][group];
                end
            end
            return false
        elseif action.Skill == "Enhancing Magic" then
            local groups = T{
                skill = T{"Aquaveil", "Stoneskin"},
                duration = T{"Blink", "Haste", "Haste II", "Flurry", "Flurry II"} -- check for barspells
            }

            for group, spells in ipairs(groups) do
                if sets.midcast['Enhancing Magic'][group] ~= nil and spells.include(action.Name) then
                    return sets.midcast['Enhancing Magic'][group]
                end
            end
        end
    end
}