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
    self.DecorateFlag   = true

    --初始化骨骼
    local cfg   = Table.Get(Table.CharacterTable, self.Model.Character)
    self.Entity = AssetManager:LoadSync(cfg.Res)
    self.Entity.transform:SetParent(Battle.FIELD.Land.Avatar.Root.transform)
    self.Entity.transform.localScale      = Vector3.one
    
    self:SetPosition(self.Model:GetPos())

    self.Comp   = self.Entity:GetComponent("Avatar")
end

function Avatar:IsDecorate()
    return self.DecorateFlag
end

function Avatar:Transform()
    local pos   = self.Model:GetPos()

    self:Dispose()

    self:Decorate()

    self:SetPosition(pos)
end

function Avatar:SetPosition(pos)
    if self:IsDecorate() == false then return end

    self.Entity.transform.localPosition = pos + self.Offset
end

function Avatar:TurnAlpha(value)
    
end

function Avatar:Face()
    if self.Comp == nil then return end

    self.Comp:Face(self.Model:GetFace() == _C.AVATAR.FACE.RIGHT and true or false)
end

function Avatar:GetPivot(pivot_name)
    if self.Comp == nil then return end

    return self.Comp[pivot_name]
end

function Avatar:GetPivotPos(pivot_name)
    local pivot = self:GetPivot(pivot_name)

    if pivot == nil then return Vector3.zero end

    return Battle.FIELD.Land.Avatar.Root.transform:InverseTransformPoint(pivot.transform.position)
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