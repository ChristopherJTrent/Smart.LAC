--- This module is only available at build time. It will be garbage collected after the profile is loaded to save memory.
AugmentTypes = {}


--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@return string
function AugmentTypes.HP(rank)
	return 'HP+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@return string
function AugmentTypes.MP(rank)
	return 'MP+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.STR(rank)
	return 'STR+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.DEX(rank)
	return 'DEX+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.VIT(rank)
	return 'VIT+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.AGI(rank)
	return 'AGI+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.INT(rank)
	return 'INT+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.MND(rank)
	return 'MND+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.CHR(rank)
	return 'CHR+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.PetAccuracy(rank)
	return 'Pet: Accuracy+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.PetRangedAccuracy(rank)
	return 'Pet: Ranged Accuracy+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.PetAttack(rank)
	return 'Pet: Attack+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.PetRangedAttack(rank)
	return 'Pet: Ranged Attack+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.PetMagicAccuracy(rank)
	return 'Pet: Magic Accuracy+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.PetMagicDamage(rank)
	return 'Pet: Magic Damage+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.Accuracy(rank)
	return 'Accuracy+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.Attack(rank)
	return 'Attack+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.RangedAccuracy(rank)
	return 'Ranged Accuracy+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.RangedAttack(rank)
	return 'Ranged Attack+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.MagicAccuracy(rank)
	return 'Magic Accuracy+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.MagicDamage(rank)
	return 'Magic Damage+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.Evasion(rank)
	return 'Evasion+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.MagicEvasion(rank)
	return 'Magic Evasion+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.WeaponskillDamage(rank)
	return 'Weapon skill damage+' ..tostring(rank).."%"
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.CriticalHitRate(rank)
	return 'Critical Hit Rate+' ..tostring(rank)..'%'
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.StoreTP(rank)
	return '"Store TP"+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@return string
function AugmentTypes.DoubleAttack(rank)
	return '"Dbl.Atk."+'..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.Haste(rank)
	return 'Haste+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.DualWield(rank)
	return '"Dual Wield"+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.EnmityIncrease(rank)
	return 'Enmity+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.EnmityDecrease(rank)
	return 'Enmity-' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.Snapshot(rank)
	return '"Snapshot"+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.MagicAttackBonus(rank)
	return '"Magic Atk. Bonus"+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.FastCast(rank)
	return '"Fast Cast+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.CurePotency(rank)
	return '"Cure" potency+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.WaltzPotency(rank)
	return '"Waltz" potency+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.PetRegen(rank)
	return 'Pet: Regen`+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.PetHaste(rank)
	return 'Pet: Haste+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.Defense(rank)
	return 'DEF+' ..tostring(rank)
end

AugmentTypes.Defence = AugmentTypes.Defense

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.PhysicalDamageTaken(rank)
	return 'Physical damage taken-' ..tostring(rank)..'%'
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.MagicDamageTaken(rank)
	return 'Magic damage taken-' ..tostring(rank)..'%'
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.DamageTaken(rank)
	return 'Damage taken-'..tostring(rank)..'%'
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.Regen(rank)
	return 'Regen+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.Counter(rank)
	return 'Counter+' ..tostring(rank)..'%'
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.BlockRate(rank)
	return 'Block rate+' ..tostring(rank)..'%'
end

--- This function is only available at build time. It will be garbage collected on profile load to save memory.
---@param rank integer
---@returns string
function AugmentTypes.ParryRate(rank)
	return 'Parry rate+' ..tostring(rank)..'%'
end

--- This function is only available at build time. It will be garbage collected when your profile is loaded.
---@param rank integer
---@returns string
function AugmentTypes.StatusResist(rank)
	return 'Status ailment resistance+' ..tostring(rank)
end

--- This function is only available at build time. It will be garbage collected when your profile is loaded.
---@param rank integer
---@returns string
function AugmentTypes.SpellInterruptionRate(rank)
	return 'Spell Interruption Rate-' ..tostring(rank)..'%'
end

--- This function is only available at build time. It will be garbage collected when your profile is loaded.
---@param rank integer
---@returns string
function AugmentTypes.PetPhysicalDamageTaken(rank)
	return 'Pet: Physical damage taken-' ..tostring(rank)..'%'
end

--- This function is only available at build time. It will be garbage collected when your profile is loaded.
---@param rank integer
---@returns string
function AugmentTypes.PetMagicDamageTaken(rank)
	return 'Pet: Magic damage taken-'..tostring(rank)..'%'
end

--- This function is only available at build time. It will be garbage collected when your profile is loaded.
---@param rank integer
---@returns string
function AugmentTypes.PetDamageTaken(rank)
	return 'Pet: Damage taken-' ..tostring(rank)..'%'
end