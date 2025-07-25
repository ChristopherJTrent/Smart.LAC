---@meta
---@alias abilityHandler fun(sets: sets):boolean
---@class Helpers
---if the argument isn't an Ashita meta-table, make it one.
---@field EnsureSugaredTable fun(t: table): table
---@field ContainsAllKeys fun(t: table, other: table): boolean
---@field ValidatePlayerData fun(t: playerData): boolean
---@field ValidateSets fun(sets: sets): boolean
---@field AddModHeader fun(string: string): string
---@field SucceedOrWarn fun(success: boolean, good: string, bad: string): string
---@field SucceedOrError fun(success: boolean, good: string, bad: string): string
---@field GetWeaponskillProperty fun(ability: Action): skillchainData
---@field GenericAbilityHandler fun(sets: sets, key:string):boolean
---@field CleanupSets fun(sets: sets):sets
---@field CreateRequiredFiles function
---@field PerformUpdateCheck function
---@field ProfileFileExists fun(name: string):boolean
---@field SmartFileExists fun(name: string):boolean
---@field SubJobHasChanged function
---@field BuildPlatformPath fun(...:string):string