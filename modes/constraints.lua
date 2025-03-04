local DualWieldAbilityID = AshitaCore:GetResourceManager():GetAbilityByName("Dual Wield", 0).Id

---@type table<string, Constraint>
Constraints = {
}

function Constraints.HasDualWield()
	return AshitaCore:GetMemoryManager():GetPlayer():HasAbility(DualWieldAbilityID)
end