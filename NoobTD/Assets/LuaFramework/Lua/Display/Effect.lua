--Effect: 表现特效

local Effect = Class.define("Display.Effect")

function Effect:ctor(resPath, parent, pos)
    self.Finished   = false
    self.ResPath    = resPath
    self.Pos        = pos

    self.Entity     = AssetManager:LoadSync(self.ResPath)
    self.Entity.transform:SetParent(parent.transform)
    self.Entity.transform.localPosition = pos
end

function Effect:Show(flag)
    self.Entity:SetActive(flag)    
end

function Effect:Dispose()
    destroy(self.Entity)
end

return Effect