local ret = {
    hash = {},
    deduplicated = {},
    filter = T{
        "AugPath",
        "AugRank",
        "AugTrial",
        "Augment",
        "Bag"
    }
}

function ret:process(t)
    if t == nil then 
        print("Nil was passed to packerBuilder:process")
        return 
    end
    for k, v in pairs(t) do
        if not self.filter:find(k) then 
            if type(v) == "string" then
                if self.hash[v] == nil then
                    self.deduplicated[#self.deduplicated + 1] = v
                    self.hash[v] = true
                end
            elseif v.Name then
                if self.hash[v.Name] == nil then
                    self.hash[v.Name] = true
                    if v.Quantity then
                        self.deduplicated[#self.deduplicated + 1] = {Name = v.Name, Quantity = v.Quantity}
                    else 
                        self.deduplicated[#self.deduplicated + 1] = v.Name
                    end
                end
            elseif type(v) == "table" then
                self:process(v)
            end
        end
    end
end

function ret:get()
    return self.deduplicated
end

return ret