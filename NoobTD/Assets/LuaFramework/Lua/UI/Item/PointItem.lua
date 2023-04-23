local PointItem = {}

function PointItem:Awake(items)
    self.GO         = items["This"]
    self.Normal     = items["Normal"]
    self.Light      = items["Light"]
end

function PointItem:Show(flag)
    self.Normal:SetActive(not flag)    
    self.Light:SetActive(flag)   
end

function PointItem:OnDestroy()

end


return PointItem