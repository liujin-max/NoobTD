local HPBar = {}

function HPBar:Awake(items)
    self.GO     = items["This"]
    self.Bottom = items["Bottom"]
    self.HP     = items["HP"]
end

function HPBar:SetFollow(target)
    local UIFollow = self.GO:GetComponent("UIFollow")
    UIFollow:SetFollow(target.transform)
end

function HPBar:FlushHP(hp, total_hp)
    self.HP.fillAmount = hp / total_hp
end

function HPBar:OnDestroy()

end

return HPBar