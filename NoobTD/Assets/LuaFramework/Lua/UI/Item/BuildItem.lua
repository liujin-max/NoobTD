local BuildItem = {}

function BuildItem:Awake(items)
    self.GO         = items["This"]
    self.Name       = items["Name"]

end

--传进来效果器
--功能在效果器里实现
function BuildItem:Init(event_effect)
    self.EventEffect= event_effect

    self.Name.text  = event_effect:Description()
end

function BuildItem:OnDestroy()

end


return BuildItem