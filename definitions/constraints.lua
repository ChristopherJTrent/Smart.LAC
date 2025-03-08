local DualWieldAbilityID = AshitaCore:GetResourceManager():GetAbilityByName("Dual Wield", 0).Id

Constraint = {
}

function Constraint.HasDualWield()
	return AshitaCore:GetMemoryManager():GetPlayer():HasAbility(DualWieldAbilityID)
end

function Constraint.Invert(constraint)
    return function()
        return not constraint()
    end
end