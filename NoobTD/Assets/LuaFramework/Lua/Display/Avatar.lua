local Avatar = Class.define("Display.Avatar")

function Avatar:ctor(fighter, parent)
    self.Model      = fighter

    self.Offset     = Vector3.zero

    self.DecorateFlag   = false
end

function Avatar:RandomOffset()
    self.Offset     = Vector3.New(math.random(-40, 40) / 100.0, math.random(-40, 40) / 100.0, 0)
end

function Avatar:Decorate()
    --初始化骨骼
    local cfg   = Table.Get(Table.CharacterTable, self.Model.Character)
    self.Entity = AssetManager:LoadSync(cfg.Res)
    self.Entity.transform:SetParent(Battle.FIELD.Land.Avatar.Root.transform)
    self.Entity.transform.localScale      = Vector3.one
    self.Entity.transform.localPosition   = Vector3.zero

    self.DecorateFlag   = true
end

function Avatar:Transform()
    local pos   = self:GetPosition()

    self:Dispose()

    self:Decorate()
    self:SetPosition(pos)

end

function Avatar:SetPosition(pos)
    self.Entity.transform.localPosition = pos + self.Offset
end

function Avatar:GetPosition()
    return self.Entity.transform.localPosition - self.Offset
end

function Avatar:GetPivotPos(pivot)
    local base  = self:GetPosition()

    if pivot == _C.AVATAR.PIVOT.HEAD then
        base    = base + self.Offset + Vector3.New(0, 0.5, 0)
    end

    return base
end

function Avatar:FlushHP(value, max)
    if self.HPBar == nil then
        --初始化血条
        self.HPBar  = Class.new(Display.HPBar, self)
        self.HPBar:Decorate()
        self.HPBar:Init(max, max)
    end
    
    self.HPBar:FlushHP(value, max)
end

function Avatar:Update(deltatime)
    if self.HPBar ~= nil then
        self.HPBar:Update(deltatime)
    end
end

function Avatar:Dispose()
    self.DecorateFlag   = false

    if self.Entity ~= nil then
        destroy(self.Entity)
    end
    self.Entity = nil


    if self.HPBar ~= nil then
        self.HPBar:Dispose()
    end
    self.HPBar  = nil


end



return Avatar