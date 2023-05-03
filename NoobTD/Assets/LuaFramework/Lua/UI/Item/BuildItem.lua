local BuildItem = {}

function BuildItem:Awake(items)
    self.GO         = items["This"]
    self.Name       = items["Name"]
    self.Price      = items["Price"]
end

--传进来效果器
--功能在效果器里实现
function BuildItem:Init(event_effect)
    self.EventEffect= event_effect

    self.Name.text  = event_effect:Description()

    local have      = Battle.FIELD:GetCoin()
    local cost      = event_effect:GetCost()
    if have >= cost then
        self.Price.text = cost
    else
        self.Price.text = _C.COLOR.RED .. cost
    end
end

function BuildItem:Execute(defender)
    self.EventEffect:Execute({Defender = defender})
    
    LuaEventManager.SendEvent(_E.BATTLE_HIDERING, nil, defender)
end

function BuildItem:OnDestroy()

end


return BuildItem