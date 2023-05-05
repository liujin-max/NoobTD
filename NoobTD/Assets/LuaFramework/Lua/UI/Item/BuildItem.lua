local BuildItem = {}

function BuildItem:Awake(items)
    self.GO         = items["This"]
    self.Name       = items["Name"]
    self.Price      = items["Price"]
    self.CheckPivot = items["CheckPivot"]


end

--传进来效果器
--功能在效果器里实现
function BuildItem:Init(event_effect, defender)
    self.EventEffect= event_effect
    self.Defender   = defender

    self.Name.text  = event_effect:Description()

    local have      = Battle.FIELD:GetCoin()
    local cost      = event_effect:GetCost()
    if have >= cost then
        self.Price.text = cost
    else
        self.Price.text = _C.COLOR.RED .. cost
    end

    self:Select(false)
end

function BuildItem:Preload()
    self.EventEffect:Preload({Defender = self.Defender})
end

function BuildItem:Execute()
    self.EventEffect:Execute({Defender = self.Defender})
    
    LuaEventManager.SendEvent(_E.BATTLE_HIDERING, nil, self.Defender)
end


function BuildItem:Select(flag)
    self.CheckPivot:SetActive(flag)
end



function BuildItem:OnDestroy()

end


return BuildItem