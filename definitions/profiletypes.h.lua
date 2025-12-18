---@meta

---@alias gearItem string | {Name: string, Augment: string[]?, AugPath: string?, Quantity: number|"all"}
---@alias headGear gearItem
---@alias bodyGear gearItem
---@alias handGear gearItem
---@alias legGear gearItem
---@alias footGear gearItem
---@alias weapon gearItem
---@alias subWeapon gearItem
---@alias range gearItem
---@alias ammo gearItem
---@alias necklace gearItem
---@alias earring gearItem
---@alias ring gearItem
---@alias cape gearItem
---@alias belt gearItem

---@class sets
---@field Main weapon?
---@field Sub weapon?
---@field Range weapon?
---@field Ammo ammo?
---@field Head headGear?
---@field Neck necklace?
---@field Ear1 earring?
---@field Ear2 earring?
---@field Body bodyGear?
---@field Hands handGear?
---@field Ring1 ring?
---@field Ring2 ring?
---@field Back cape?
---@field Waist belt?
---@field Legs legGear?
---@field Feet footGear?

---@class Agwu
---@field Head headGear
---@field Body bodyGear
---@field Hands handGear
---@field Legs legGear
---@field Feet footGear
---@field Axe weapon
---@field Greatsword weapon
---@field Scythe weapon

---@class Bunzi
---@field Head headGear
---@field Body bodyGear
---@field Hands handGear
---@field Legs legGear
---@field Feet footGear
---@field Club string
---@field Great_Axe string

---@class Gleti
---@field Head headGear
---@field Body bodyGear
---@field Hands handGear
---@field Legs legGear
---@field Feet footGear
---@field Crossbow string
---@field Dagger string
---@field Great_Katana string

---@class Ikenga
---@field Head headGear
---@field Body bodyGear
---@field Hands handGear
---@field Legs legGear
---@field Feet footGear
---@field Axe string
---@field Polearm string
---@field Katana string

---@class Mpaca
---@field Head headGear
---@field Body bodyGear
---@field Hands handGear
---@field Legs legGear
---@field Feet footGear
---@field Bow string
---@field Staff string

---@class Sakpata
---@field Head headGear
---@field Body bodyGear
---@field Hands handGear
---@field Legs legGear
---@field Feet footGear
---@field HandToHand string
---@field Sword string

---@class Odyssey
---@field Agwu Agwu
---@field Bunzi Bunzi
---@field Gleti Gleti
---@field Ikenga Ikenga
---@field Mpaca Mpaca
---@field Sakpata Sakpata

---@class JSE_AR
---@field Head headGear
---@field Body bodyGear
---@field Hands handGear
---@field Legs legGear
---@field Feet footGear

---@class JSE_E
---@field Head headGear
---@field Body bodyGear
---@field Hands handGear
---@field Legs legGear
---@field Feet footGear
---@field Earring string|table

---@class JSE_C
---@field Adoulin { [string]: string|table }
---@field Ambuscade { [string]: string|table }

---@class JSE
---@field Artifact JSE_AR
---@field Relic JSE_AR
---@field Empyrean JSE_E
---@field Capes JSE_C