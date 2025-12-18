local DualWieldAbilityID = AshitaCore:GetResourceManager():GetAbilityByName("Dual Wield", 0).Id

---@alias constraint fun():boolean
---@alias constraintFactory<T> fun(T):constraint

---@class Constraints
---@field HasDualWield constraint
---@field Invert constraintFactory<constraint>
---@field HasSubjob constraintFactory<string>
Constraint = {
}

function Constraint.HasDualWield()
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

function Constraint.HasSubjob(subjob) 
    return function()
        return gData.GetPlayer().SubJob == subjob
    end
end
