local DualWieldAbilityID = AshitaCore:GetResourceManager():GetAbilityByName("Dual Wield", 0).Id

Constraint = {
}

function Constraint.HasDualWield()
    ---@type Player
    local player = gData.GetPlayer()
    return (
        ( player.MainJob == "NIN" and player.MainJobSync > 10 )
        or ( player.SubJob == "NIN" and player.SubJobSync > 10 )
        or ( player.MainJob == "DNC" and player.MainJobSync > 20 )
        or ( player.SubJob == "DNC" and player.SubJobSync > 20 )
        or AshitaCore:GetMemoryManager():GetPlayer():HasAbility(DualWieldAbilityID)
    )    
end

function Constraint.Invert(constraint)
    return function()
        return not constraint()
    end
end