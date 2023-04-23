
local JobUpgradeWindow = {}
setmetatable(JobUpgradeWindow, {__index = WindowBase})

local P     = {}


function JobUpgradeWindow.Awake(items)
    JobUpgradeWindow.PARAMS.Mask        = items["Mask"]
    JobUpgradeWindow.PARAMS.BtnClose    = items["BtnClose"]

    JobUpgradeWindow.PARAMS.Content     = items["Content"]
    JobUpgradeWindow.PARAMS.OJob        = items["OJob"]
    JobUpgradeWindow.PARAMS.Job         = items["Job"]
    JobUpgradeWindow.PARAMS.OSalary     = items["OSalary"]
    JobUpgradeWindow.PARAMS.Salary      = items["Salary"]
    JobUpgradeWindow.PARAMS.Description = items["Description"]
    JobUpgradeWindow.PARAMS.Cost        = items["Cost"]
    JobUpgradeWindow.PARAMS.UnlockPivot = items["UnlockPivot"]
    JobUpgradeWindow.PARAMS.JobPivot    = items["JobPivot"]
    JobUpgradeWindow.PARAMS.AttributePivot = items["AttributePivot"]

    JobUpgradeWindow.PARAMS.BtnUpgrade  = items["BtnUpgrade"]


    P.Attributes    = {}

    
    UIEventListener.PGet(JobUpgradeWindow.PARAMS.BtnUpgrade,    JobUpgradeWindow).onClick_P = function()
        Controller.JobUpgrade.Upgrade(P.Staff,  P.JobItem.Job.ID)
    end

    UIEventListener.PGet(JobUpgradeWindow.PARAMS.Mask,          JobUpgradeWindow).onClick_P = function()
        UI.JobUpgradeWindow.ProgressHide(UI.JobUpgradeWindow,_C.UI.WINDOW.JOBUPGRADE)
    end

    UIEventListener.PGet(JobUpgradeWindow.PARAMS.BtnClose,      JobUpgradeWindow).onClick_P = function()
        UI.JobUpgradeWindow.ProgressHide(UI.JobUpgradeWindow,_C.UI.WINDOW.JOBUPGRADE)
    end
end

function JobUpgradeWindow.Init(staff)
    P.Staff     = staff

    JobUpgradeWindow.InitAttributes(staff)
    JobUpgradeWindow.InitJobs(staff)
end

function JobUpgradeWindow.InitAttributes(staff)
    for i = _C.ATTRIBUTE.PLAN , _C.ATTRIBUTE.MUSIC  do
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.ATTRIBUTE, JobUpgradeWindow.PARAMS.AttributePivot)
        item:Init(i, staff:GetAttribute(i))
        item:ShowBottom(true)
        P.Attributes[i] = item
    end
end

function JobUpgradeWindow.InitJobs(staff)
    local c_job = staff.Job
    local nexts = c_job:GetNexts()
    
    JobUpgradeWindow.PARAMS.JobPivot:SetActive(#nexts > 1)

    for i, job_id in ipairs(nexts) do
        local job   = Controller.Data.Menu():GetJob(job_id)

        local item  = UI.Manager:LoadItem(_C.UI.ITEM.JOB, JobUpgradeWindow.PARAMS.Content.transform)
        item:Init(job)

        if P.JobItem == nil then
            JobUpgradeWindow.SelectJob(item)
        end

        UISimpleEventListener.PGet(item.GO, item).onClick_P = function()
            if P.JobItem == item then return end

            JobUpgradeWindow.SelectJob(item)
        end
    end
end

function JobUpgradeWindow.SelectJob(item)
    if P.JobItem ~= nil then
        P.JobItem:HighLight(false)
    end

    P.JobItem   = item
    P.JobItem:HighLight(true)

    JobUpgradeWindow.FlushJobUI(item.Job)
end

function JobUpgradeWindow.FlushJobUI(job)
    local o_job     = P.Staff.Job
    JobUpgradeWindow.PARAMS.OJob.text   = o_job.Name
    JobUpgradeWindow.PARAMS.OSalary.text = SetShowNumber(P.Staff:GetSalary()) .. "/月"

    JobUpgradeWindow.PARAMS.Job.text     = job.Name
    JobUpgradeWindow.PARAMS.Salary.text  = SetShowNumber(P.Staff:GetSalary(job)) .. "/月"

    --升级后的技能
    local n_staff     = clone(P.Staff)
    n_staff:JobUpgrade(job)

    local description = n_staff:GetSkillDescription()
    JobUpgradeWindow.PARAMS.UnlockPivot:SetActive(description ~= "")
    JobUpgradeWindow.PARAMS.Description.text    = description

    local atr_data  = Controller.Data.School().UpgradeDemand(P.Staff, job)
    for k, item in pairs(P.Attributes) do
        local cur   = P.Staff:GetAttribute(k)
        local need  = atr_data[k]
        item:SetScore(need, cur >= need and _C.COLOR.GREEN2 or _C.COLOR.RED)
    end

    local research_cost     = job:GetResearchCost()

    if Controller.Data.Account():GetResearchCount() < research_cost then
        JobUpgradeWindow.PARAMS.Cost.text   = _C.COLOR.RED .. research_cost .. "</color>"
    else
        JobUpgradeWindow.PARAMS.Cost.text   = research_cost
    end
end




function JobUpgradeWindow.OnDestroy()
    P       = {}
end



return JobUpgradeWindow