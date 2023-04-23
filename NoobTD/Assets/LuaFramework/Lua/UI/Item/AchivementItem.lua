local AchivementItem = {}

function AchivementItem:Awake(items)
    self.GO             = items["This"]
    self.Name           = items["Name"]
    self.Description    = items["Description"]
end

function AchivementItem:Init(achivement_task)
    self.Name.text      = achivement_task.Name
    self.Description.text   = achivement_task.Description
end

function AchivementItem:OnDestroy()

end


return AchivementItem