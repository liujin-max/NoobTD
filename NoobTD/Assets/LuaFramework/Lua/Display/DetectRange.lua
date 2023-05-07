local DetectRange = Class.define("Display.DetectRange")

function DetectRange:ctor(field)
    self.Field  = field
end

function DetectRange:Decorate()
    self.Entity = AssetManager:LoadSync("Prefab/Battle/DetectRange")
    self.Entity.transform:SetParent(self.Field.Land.Avatar.Root.transform)
    self.Entity.transform.localScale      = Vector3.one
    self.Entity.transform.localPosition   = Vector3.zero

end

function DetectRange:Show(flag, range, pos)
    if flag == true then
        if self.Entity == nil then
            self:Decorate()
        end

        local base  = 200 / 2
        local scale = range / base

        self.Entity.transform.localScale    = Vector3.New(scale, scale, scale)
        self.Entity.transform.localPosition = pos
        
        self.Entity:SetActive(true)
    else
        if self.Entity ~= nil then
            self.Entity:SetActive(false)
        end
    end    
end

function DetectRange:Dispose()
    if self.Entity ~= nil then
        destroy(self.Entity)
    end
    self.Entity = nil
end



return DetectRange