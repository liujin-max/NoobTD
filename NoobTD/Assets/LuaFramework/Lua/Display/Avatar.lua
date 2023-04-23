local Avatar = Class.define("Display.Avatar")

function Avatar:ctor(fighter, parent)
    self.Model      = fighter


end

function Avatar:Decorate()
    self.Entity = AssetManager:LoadSync("Prefab/Battle/Monster")
    self.Entity.transform:SetParent(Battle.FIELD.Land.Avatar.Root.transform)
    self.Entity.transform.localScale      = Vector3.New(0.5, 0.5, 0.5)
    self.Entity.transform.localPosition   = Vector3.zero
end

function Avatar:SetPosition(pos)
    self.Entity.transform.localPosition = pos    
end

function Avatar:GetPosition()
    return self.Entity.transform.localPosition
end


function Avatar:Dispose()
    if self.Entity ~= nil then
        destroy(self.Entity)
    end
    self.Entity = nil
end



return Avatar