--Effect: 表现特效

local Effect = Class.define("Display.Effect")

function Effect:ctor(resPath, parent, pos)
    self.Entity     = AssetManager:LoadSync(resPath)
    self.Entity.transform:SetParent(parent.transform)
    self.Entity.transform.localPosition = pos
end

function Effect:Show(flag)
    self.Entity:SetActive(flag)    
end

function Effect:SetPos(pos)
    self.Entity.transform.localPosition = pos
end

function Effect:GetPos()
    return self.Entity.transform.localPosition
end

function Effect:Dispose()
    destroy(self.Entity)
end

return Effect