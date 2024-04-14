---@meta 

---@alias Element 'Fire' | 'Ice' | 'Wind' | 'Earth' | 'Water' | 'Light' | 'Dark'
---@alias CallType 'OnLoad' | 'OnUnload' | 'HandleCommand' | 'HandleDefault' | 'HandleAbility' | 'HandleItem' | 'HandlePrecast' | 'HandleMidcast' | 'HandlePreshot' | 'HandleMidshot' | 'HandleWeaponskill' | 'N/A'
---@alias Skill 'Divine Magic' | 'Healing Magic' | 'Enhancing Magic' | 'Enfeebling Magic' | 'Elemental Magic' | 'Dark Magic' | 'Summoning' | 'Ninjutsu' | 'Singing' | 'Blue Magic' | 'Geomancy' | 'Unknown'
---@alias SpellType 'White Magic' | 'Black Magic' | 'Summoning' | 'Ninjutsu' | 'Bard Song' | 'Blue Magic' | 'Unknown'
---@alias AbilityType 'Rune Enchantment' | 'Ready' | 'Blood Pact: Rage' | 'Blood Pact: Ward' | 'Corsair Roll' | 'Quick Draw' | 'Unknown'
---@alias EntityStatus 'Idle' | 'Engaged' | 'Dead' | 'Zoning' | 'Resting' | 'Unknown'
---@alias EntityType 'PC' | 'NPC' | 'Alliance' | 'Party' | 'Monster' | 'Unknown'
---@alias Day 'Firesday' | 'Earthsday' | 'Watersday' | 'Windsday' | 'Iceday' | 'Lightningday' | 'Lightsday' | 'Darksday' | 'Unknown'
---@alias MoonPhase 'Full Moon' | 'Waning Gibbous' | 'Last Quarter' | 'Waning Crescent' | 'New Moon' | 'Waxing Crescent' | 'First Quarter' | 'Waxing Gibbous' | 'Unknown'
---@alias WeatherType 'Clear' | 'Sunshine' | 'Clouds' | 'Fog' | 'Fire' | 'Fire x2' | 'Water' | 'Water x2' | 'Earth' | 'Earth x2' | 'Wind' | 'Wind x2' | 'Ice' | 'Ice x2' | 'Thunder' | 'Thunder x2' | 'Light' | 'Light x2' | 'Dark' | 'Dark x2' | 'Unknown'
---@alias WeatherElement Element | 'None' | 'Unknown'

---@class Time
---@field day number
---@field hour number
---@field minute number

---@class item_t
---@field Id number
---@field Index number
---@field Count number
---@field Flags integer
---@field Price number
---@field Extra number[]

---@class FFIEquipment
---@field Container number
---@field Item item_t
---@field Name string
---@field Resource IItem