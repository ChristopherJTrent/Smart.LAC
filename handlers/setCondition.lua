---@return boolean
---@param target Player | Pet | Entity | Environment
---@param node conditionNode
local oHandleNode = function(target, node)
	if(target[node.dataField]) then
		return (target[node.dataField] == node.dataValue) ~= node.negateCondition
	end
	return false
end
---@return boolean
---@param target string
---@param node conditionNode
local handleNode = function(target, node)
	if(node.targetOverride) then target = node.targetOverride end
	if(target == 'Player') then
		return oHandleNode(gData.GetPlayer(), node)
	elseif (target == 'Pet') then
		return oHandleNode(gData.GetPet(), node)
	elseif (target == 'Target') then
		return oHandleNode(gData.GetActionTarget(), node)
	elseif (target == 'Environment') then
		return oHandleNode(gData.GetEnvironment(), node)
	else
		print(Helpers.addModHeader(chat.error('Invalid condition target "'..target..'". Condition will be considered false.')))
		return false
	end
end

---@param t conditions
local handle = function(t)
	if(not t.nodes.any) then t.nodes = T(t.nodes) end
	if(t.conditionType == 'OR') then
		return t.nodes:any(function(v)
			return handleNode(t.defaultTarget, v)
		end)
	else 
		return t.nodes:all(function(v)
			return handleNode(t.defaultTarget, v)
		end)
	end
end


---@type setConditionHandler
return {
	handle = handle
}