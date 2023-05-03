local HPBar = Class.define("Display.HPBar")

function HPBar:ctor(avatar)
    self.Avatar     = avatar

end

function HPBar:Decorate()
    self.Item = UI.Manager:LoadSceneItem(_C.UI.ITEM.HPBAR)
    
    self:Follow()
end

function HPBar:Show(flag)
    if self.Item ~= nil then
        self.Item.GO:SetActive(flag)
    end    
end

function HPBar:Follow()
    local pos = self.Avatar:GetPivotPos(_C.AVATAR.PIVOT.HEAD)
    self.Item.GO.transform.localPosition  = pos * 100
end

function HPBar:Update(deltatime)
    if self.Item ~= nil then
        self.Item:Update(deltatime)

        self:Follow()
    end
end

function HPBar:Init(value, max)
    self.Item:Init(value, max)
end

function HPBar:FlushHP(value, max)
    self.Item:FlushHP(value, max)
end

function HPBar:Dispose()
    if self.Item ~= nil then
        UI.Manager:UnloadItem(self.Item)
    end
    self.Item = nil
end



return HPBar