local JobItem = {}

function JobItem:Awake(items)
    self.GO         = items["This"]
    self.Normal     = items["Normal"]
    self.Name       = items["Name"]

    self.Light      = items["Light"]
    self.LightName  = items["LightName"]

end

--蓝色94C4F9
--黄色FBEA8D
function JobItem:Init(job)
    self.Job        = job
    
    self.Name.text      = job.Name
    self.LightName.text = job.Name

    self:HighLight(false)
end

function JobItem:HighLight(flag)
    self.Normal:SetActive(not flag)
    self.Light:SetActive(flag)
end

function JobItem:OnDestroy()

end


return JobItem