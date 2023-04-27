local Avatar = Class.define("Display.Avatar")

function Avatar:ctor(fighter, parent)
    self.Model      = fighter

    self.Offset     = Vector3.zero --Vector3.New(math.random(-50, 50) / 100.0, math.random(-50, 50) / 100.0, 0)

    self.DecorateFlag   = false
end

function Avatar:Decorate()
    self.Entity = AssetManager:LoadSync("Prefab/Character/" .. self.Model.ID)
    self.Entity.transform:SetParent(Battle.FIELD.Land.Avatar.Root.transform)
    self.Entity.transform.localScale      = Vector3.New(0.5, 0.5, 0.5)
    self.Entity.transform.localPosition   = Vector3.zero


    self.DecorateFlag   = true
end

function Avatar:SetPosition(pos)
    self.Entity.transform.localPosition = pos + self.Offset
end

function Avatar:GetPosition()
    return self.Entity.transform.localPosition - self.Offset
end

function Avatar:FlushHP(value, max)
    
end

function Avatar:FlushARMOR(value, max)
    
end

function Avatar:Dispose()
    self.DecorateFlag   = false


    if self.Entity ~= nil then
        destroy(self.Entity)
    end
    self.Entity = nil
end



return Avatar