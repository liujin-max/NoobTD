local JobCentreItem = {}

function JobCentreItem:Awake(items)
    self.Normal     = items["Normal"]
    self.Light      = items["Light"]
end


function JobCentreItem:Init(job_centre)
    self.JobCentre  = job_centre

    self.Normal.transform:Find("Name"):GetComponent("TextMeshProUGUI").text = job_centre.Name
    self.Light.transform:Find("Name"):GetComponent("TextMeshProUGUI").text = job_centre.Name

    self:Show(false)
end

function JobCentreItem:Show(flag)
    self.Normal:SetActive(not flag)
    self.Light:SetActive(flag)
end

function JobCentreItem:OnDestroy()

end


return JobCentreItem