---@type jobHandler
return {
    midcast = function(action, sets)
        if action.Type == "Bard Song" then
            if sets.settings ~= nil and sets.settings.DummySongs ~= nil then
                if T(sets.settings.DummySongs):contains(action.Name) then
                    return sets.midcast.dummySongs ~= nil and sets.midcast.dummySongs or false
                end
            end
        end
        return false
    end
}