return {
    midcast = function(action, sets)
        if sets.midcast == nil then return false end
        if action.Skill == "Enfeebling Magic" then
            if sets.midcast['Enfeebling Magic'] == nil then return false end
            local finalSet = sets.midcast['Enfeebling Magic'].default or {}
            local groups = T{
                highSkill = T{"Distract III", "Frazzle III"},
                lowSkill = T{"Poison", "Poison II"},
                skill = T{"Distract III", "Frazzle III", "Poison", "Poison II"},
                duration = T{"Inundation"},
                mAccDuration = T{"Sleep", "Sleep II", "Bind", "Break", "Silence"},
                mAccPotency = T{"Gravity", "Gravity II"},
                mAcc = T{"Frazzle", "Frazzle II", "Dispel", "Distract", "Distract II"},
                MND = T{"Paralyze", "Paralyze II", "Addle", "Addle II", "Slow", "Slow II"},
                INT = T{"Blind", "Blind II"}
            }

            for group, spells in ipairs(groups) do
                if sets.midcast['Enfeebling Magic'][group] ~= nil and spells.include(action.Name) then
                    return gFunc.Combine(finalSet, sets.midcast['Enfeebling Magic'][group])
                end
            end
            if sets.midcast['Enfeebling Magic'].default ~= nil then
                return sets.midcast['Enfeebling Magic'].default 
            else 
                return false 
            end
        elseif action.Skill == "Enhancing Magic" then
            if sets.midcast['Enhancing Magic'] ~= nil then 
                local groups = T{
                    skill = T{"Aquaveil", "Stoneskin", "Temper", "Temper II"},
                    duration = T{"Blink", "Haste", "Haste II", "Flurry", "Flurry II"} -- check for barspells
                }
                
                local finalSet = sets.midcast['Enhancing Magic'].default or {}
                for group, spells in ipairs(groups) do
                    if sets.midcast['Enhancing Magic'][group] ~= nil and spells.include(action.Name) then
                        return gFunc.Combine(finalSet, sets.midcast['Enhancing Magic'][group])
                    end
                end
                if string.find(action.Name, "bar") ~= nil then
                    return gFunc.Combine(finalSet, sets.midcast['Enhancing Magic'].duration)
                end
                if sets.midcast.skill ~= nil and string.find(action.Name, "^En.*") ~= nil then
                    return gFunc.Combine(finalSet, sets.midcast.skill)
                end
                if string.find(action.Name, "Gain") ~= nil then
                    return gFunc.Combine(
                        finalSet, 
                        sets.midcast['Enhancing Magic'].skill ~= nil and sets.midcast['Enhancing Magic'].skill or {}, 
                        sets.midcast['Enhancing Magic'].gainspell ~= nil and sets.midcast['Enhancing Magic'].gainspell or {}
                    )
                end
                if sets.midcast['Enhancing Magic'].default ~= nil then
                    return sets.midcast['Enhancing Magic'].default
                else
                    return false
                end
            end

        end

    end
}