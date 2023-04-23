
local JobCentreWindow = {}
setmetatable(JobCentreWindow, {__index = WindowBase})

local P     = {}


function JobCentreWindow.Awake(items)
    JobCentreWindow.PARAMS.Mask         = items["Mask"]
    JobCentreWindow.PARAMS.BtnClose     = items["BtnClose"]
    JobCentreWindow.PARAMS.BtnHire      = items["BtnHire"]
    JobCentreWindow.PARAMS.ArrowLeft    = items["ArrowLeft"]
    JobCentreWindow.PARAMS.ArrowRight   = items["ArrowRight"]
    JobCentreWindow.PARAMS.PointContent = items["PointContent"]

    JobCentreWindow.PARAMS.SK           = items["SK"]
    JobCentreWindow.PARAMS.Skill        = items["Skill"]

    JobCentreWindow.PARAMS.Name             = items["Name"]
    JobCentreWindow.PARAMS.Job              = items["Job"]
    JobCentreWindow.PARAMS.Salary           = items["Salary"]
    JobCentreWindow.PARAMS.AttributePivot   = items["AttributePivot"]

    P.Attributes    = {}
    P.Points        = Class.new(Array)
    
    UIEventListener.PGet(JobCentreWindow.PARAMS.Mask,   JobCentreWindow).onClick_P = function()
        Controller.HR.Dispose()
    end

    UIEventListener.PGet(JobCentreWindow.PARAMS.BtnClose,   JobCentreWindow).onClick_P = function()
        Controller.HR.Dispose()
    end

    UIEventListener.PGet(JobCentreWindow.PARAMS.BtnHire,   JobCentreWindow).onClick_P = function()
        Controller.HR.Hire(Controller.HR.CurrentStaff())
    end

    UIEventListener.PGet(JobCentreWindow.PARAMS.ArrowLeft,   JobCentreWindow).onClick_P = function()
        Controller.HR.SwitchLeft()
    end

    UIEventListener.PGet(JobCentreWindow.PARAMS.ArrowRight,   JobCentreWindow).onClick_P = function()
        Controller.HR.SwitchRight()
    end
end

function JobCentreWindow.Init()
    JobCentreWindow.InitAttributes()
    JobCentreWindow.InitPoints()
    JobCentreWindow.FlushUI()
end

function JobCentreWindow.InitAttributes()
    for i = _C.ATTRIBUTE.PLAN , _C.ATTRIBUTE.MUSIC  do
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.ATTRIBUTE, JobCentreWindow.PARAMS.AttributePivot)
        item:Init(i, 0)

        P.Attributes[i] = item
    end
end

function JobCentreWindow.InitPoints()
    P.Points:Each(function(item)
        UI.Manager:UnloadPointItem(item)        
    end)
    P.Points:Clear()
    
    local staff_count   = Controller.HR.GetStaffCount()

    for i = 1, staff_count do
       local item   = UI.Manager:LoadPointItem(JobCentreWindow.PARAMS.PointContent) 
       item:Show(false)
       P.Points:Add(item)
    end
end

function JobCentreWindow.FlushUI()
    local staff     = Controller.HR.CurrentStaff()
    local job       = staff.Job

    JobCentreWindow.PARAMS.Name.text    = staff.Name
    JobCentreWindow.PARAMS.Job.text     = job.Name
    JobCentreWindow.PARAMS.Salary.text  = SetShowNumber(staff:GetSalary()) .. "/月"


    for k, item in pairs(P.Attributes) do
        item:SetScore(staff:GetAttribute(k))
    end

    P.Points:Each(function(item, idx)
        item:Show(idx == Controller.HR.CurrentIndex())
    end)

    local staff_count   = Controller.HR.GetStaffCount()
    JobCentreWindow.PARAMS.ArrowLeft:SetActive(staff_count > 1)
    JobCentreWindow.PARAMS.ArrowRight:SetActive(staff_count > 1)

    
    JobCentreWindow.PARAMS.SK:SetActive(staff.Skills:Count() > 0)
    JobCentreWindow.PARAMS.Skill.text   = staff:GetSkillDescription()

end


function JobCentreWindow.OnDestroy()
    P.Points:Each(function(item)
        UI.Manager:UnloadPointItem(item)
    end)

    P   = {}
end



return JobCentreWindow