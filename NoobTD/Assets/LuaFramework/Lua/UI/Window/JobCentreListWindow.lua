
local JobCentreListWindow = {}
setmetatable(JobCentreListWindow, {__index = WindowBase})

local P     = {}


function JobCentreListWindow.Awake(items)
    JobCentreListWindow.PARAMS.Mask         = items["Mask"]
    JobCentreListWindow.PARAMS.BtnConfirm   = items["BtnConfirm"]

    JobCentreListWindow.PARAMS.Cost         = items["Cost"]
    JobCentreListWindow.PARAMS.TitlePivot   = items["TitlePivot"]
    JobCentreListWindow.PARAMS.TabPivot     = items["TabPivot"]
    JobCentreListWindow.PARAMS.Description  = items["Description"]

    UIEventListener.PGet(JobCentreListWindow.PARAMS.Mask,    JobCentreListWindow).onClick_P = function()
        Controller.HR.Dispose()
    end
    
    UIEventListener.PGet(JobCentreListWindow.PARAMS.BtnConfirm,    JobCentreListWindow).onClick_P = function()
        if P.TabItem == nil then
            return
        end
        Controller.HR.DoCentre(P.TabItem.JobCentre)
    end
end

function JobCentreListWindow.Init()
    JobCentreListWindow.InitCentres()
end

function JobCentreListWindow.InitCentres()
    local centres  = Controller.Data.HR():GetJobCentres()

    local count = 1
    centres:Each(function(job_centre)
        if job_centre:IsUnlock() then
            local pivot = JobCentreListWindow.PARAMS.TabPivot.transform:Find("P" .. count)
            local item  = UI.Manager:LoadItem(_C.UI.ITEM.JOBCENTRE, pivot.transform)
            item:Init(job_centre)

            if count == 1 then
                JobCentreListWindow.SelectCentre(item)
            end
    
            UISimpleEventListener.PGet(item.GO, item).onClick_P = function()
                JobCentreListWindow.SelectCentre(item)
            end

            count   = count + 1
        end
    end)
end

function JobCentreListWindow.SelectCentre(item)
    if P.TabItem ~= nil then
        P.TabItem:Show(false)           
    end

    P.TabItem   = item
    P.TabItem:Show(true)

    local job_centre    = item.JobCentre

    local cost  = job_centre:GetCost()
    if Controller.Data.IsMoneyEnough(cost) == true then
        JobCentreListWindow.PARAMS.Cost.text    = SetShowNumber(cost)
    else
        JobCentreListWindow.PARAMS.Cost.text    = _C.COLOR.RED .. SetShowNumber(cost) .. "元" .. "</color>"
    end

    JobCentreListWindow.PARAMS.Description.text = job_centre.Description

    local title     = job_centre.Name
    for i = 1, 4 do
        local t = JobCentreListWindow.PARAMS.TitlePivot.transform:Find("T" .. i):GetComponent("TextMeshProUGUI")
        t.text  = utf8sub(title, i, 1 )
    end
end



function JobCentreListWindow.OnDestroy()
    P   = {}
end



return JobCentreListWindow