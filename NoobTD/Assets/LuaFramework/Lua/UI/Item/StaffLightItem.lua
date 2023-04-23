local StaffLightItem = {}

function StaffLightItem:Awake(items)
    self.GO         = items["This"]


end

function StaffLightItem:Init(staff)
    self.Data       = staff
end

function StaffLightItem:OnDestroy()

end


return StaffLightItem

