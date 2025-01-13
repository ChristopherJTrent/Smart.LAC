return {
    precast = function(action, sets)
        if sets.precast == nil then return false end
        if T{"Utsusemi: Ichi", "Utsusemi: Ni", "Utsusemi: San"}:contains(action.Name) then
            if sets.precast.utsusemi ~= nil then
                return sets.precast.utsusemi
            end
        end
    end
}