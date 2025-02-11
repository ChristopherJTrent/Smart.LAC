return {
    midcast = function(action, sets)
        if sets.midcast == nil then return false end
        if action.Skill == "Enfeebling Magic" then
            if sets.midcast['Enfeebling Magic'] == nil then return false end
            local finalSet = sets.midcast['Enfeebling Magic'].default ~= nil 
                         and sets.midcast['Enfeebling Magic'].default
                         or  {}
            local groups = T{
                {Name = "highSkill", Spells = T{"Distract III", "Frazzle III"} },
                {Name = "lowSkill", Spells = T{"Poison", "Poison II"} },
                {Name = "skill", Spells = T{"Distract III", "Frazzle III", "Poison", "Poison II"}},
                {Name = "duration", Spells = T{"Inundation"}},
                {Name = "mAccDuration", Spells = T{"Sleep", "Sleep II", "Bind", "Break", "Silence"}},
                {Name = "mAccPotency", Spells = T{"Gravity", "Gravity II"}},
                {Name = "mAcc", Spells = T{"Frazzle", "Frazzle II", "Dispel", "Distract", "Distract II"}},
                {Name = "MND", Spells = T{"Paralyze", "Paralyze II", "Addle", "Addle II", "Slow", "Slow II"}},
                {Name = "INT", Spells = T{"Blind", "Blind II"}}
            }
            for _, group in ipairs(groups) do
                if sets.midcast['Enfeebling Magic'][group.Name] ~= nil and T(group.Spells):hasval(action.Name) then
                    return gFunc.Combine(finalSet, sets.midcast['Enfeebling Magic'][group.Name])
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
                    {Name = "skill", Spells = T{"Aquaveil", "Stoneskin", "Temper", "Temper II"}},
                    {Name = "duration", Spells = T{"Blink", "Haste", "Haste II", "Flurry", "Flurry II"}} -- check for barspells
                }
                
                local finalSet = sets.midcast['Enhancing Magic'].default 
                             and sets.midcast['Enhancing Magic'].default
                             or {}
                for _, group in ipairs(groups) do
                    if sets.midcast['Enhancing Magic'][group.Name] ~= nil and group.Spells:hasval(action.Name) then
                        return gFunc.Combine(finalSet, sets.midcast['Enhancing Magic'][group.Name])
                    end
                end
                if string.find(action.Name, "Bar") ~= nil then
                    return gFunc.Combine(finalSet, sets.midcast['Enhancing Magic'].duration)
                end
                if sets.midcast['Enhancing Magic'].skill ~= nil and string.find(action.Name, "En") ~= nil then
                    return gFunc.Combine(finalSet, sets.midcast['Enhancing Magic'].skill)
                end
                if string.find(action.Name, "Gain") ~= nil then
                    return gFunc.Combine(
                        gFunc.Combine(finalSet, sets.midcast['Enhancing Magic'].skill ~= nil and sets.midcast['Enhancing Magic'].skill or {}), 
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