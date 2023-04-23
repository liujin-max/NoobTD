
local StaffMainWindow = {}
setmetatable(StaffMainWindow, {__index = WindowBase})

local P     = {}

local CounterList       = {}
local PageViewCounter   = nil


local function ParseAttribute(game_obj)
    local temp  = {}
    temp.GO     = game_obj
    temp.Count  = game_obj.transform:Find("Count"):GetComponent("TextMeshProUGUI")

    return temp
end

function StaffMainWindow.Awake(items)
    StaffMainWindow.PARAMS.Mask         = items["Mask"]
    StaffMainWindow.PARAMS.BtnClose     = items["BtnClose"]
    StaffMainWindow.PARAMS.ArrowLeft    = items["ArrowLeft"]
    StaffMainWindow.PARAMS.ArrowRight   = items["ArrowRight"]

    StaffMainWindow.PARAMS.Name         = items["Name"]
    StaffMainWindow.PARAMS.Job          = items["Job"]
    StaffMainWindow.PARAMS.Salary       = items["Salary"]
    StaffMainWindow.PARAMS.SalaryUp     = items["SalaryUp"]
    StaffMainWindow.PARAMS.JobUp        = items["JobUp"]
    StaffMainWindow.PARAMS.Skill        = items["Skill"]

    -- StaffMainWindow.PARAMS.CharacterPivot   = items["CharacterPivot"]

    StaffMainWindow.PARAMS.ScrollView   = items["ScrollView"]
    StaffMainWindow.PARAMS.Content      = items["Content"]
    StaffMainWindow.PARAMS.LightPivot   = items["LightPivot"]
    StaffMainWindow.PARAMS.UpgradePivot = items["UpgradePivot"]

    StaffMainWindow.PARAMS.BtnFire      = items["BtnFire"]
    StaffMainWindow.PARAMS.BtnUpgrade   = items["BtnUpgrade"]
    StaffMainWindow.PARAMS.BtnTrain     = items["BtnTrain"]
    StaffMainWindow.PARAMS.BtnForceFire = items["BtnForceFire"]


    StaffMainWindow.PARAMS.BtnForceFire:SetActive(false)

    
    P.Attributes    = {}
    P.Attributes[_C.ATTRIBUTE.PROGRAM]  = ParseAttribute(items["PROGRAM"])
    P.Attributes[_C.ATTRIBUTE.PLAN]     = ParseAttribute(items["PLAN"])
    P.Attributes[_C.ATTRIBUTE.ARTS]     = ParseAttribute(items["ARTS"])
    P.Attributes[_C.ATTRIBUTE.MUSIC]    = ParseAttribute(items["MUSIC"])



    P.StaffItems    = Class.new(Array)
    P.ScrollBegin   = false

    UIEventListener.PGet(StaffMainWindow.PARAMS.ArrowLeft,      StaffMainWindow).onClick_P  = StaffMainWindow.SwitchLeft
    UIEventListener.PGet(StaffMainWindow.PARAMS.ArrowRight,     StaffMainWindow).onClick_P  = StaffMainWindow.SwitchRight

    UIEventListener.PGet(StaffMainWindow.PARAMS.BtnFire,       StaffMainWindow).onClick_P = function()
        Controller.HR.Fire(Controller.Staff.Current())
    end

    UIEventListener.PGet(StaffMainWindow.PARAMS.BtnTrain,       StaffMainWindow).onClick_P = function()
        Controller.School.Start(Controller.Staff.Current())
    end

    UIEventListener.PGet(StaffMainWindow.PARAMS.BtnUpgrade,     StaffMainWindow).onClick_P = function()
        Controller.JobUpgrade.Start(Controller.Staff.Current())
    end

    UIEventListener.PGet(StaffMainWindow.PARAMS.BtnForceFire,   StaffMainWindow).onClick_P = function()
        Controller.HR.Replace(Controller.Staff.Current())

        Controller.Staff.Dispose()
    end

    UIEventListener.PGet(StaffMainWindow.PARAMS.Mask,           StaffMainWindow).onClick_P = function()
        Controller.Staff.Dispose()
    end

    UIEventListener.PGet(StaffMainWindow.PARAMS.BtnClose,       StaffMainWindow).onClick_P = function()
        Controller.Staff.Dispose()
    end

    UIEventListener.PGet(StaffMainWindow.PARAMS.ScrollView, StaffMainWindow).onDragBegin_P  = function(pself, go, eventData)
        StaffMainWindow.ShowItemLight(false)
    end


    LuaEventManager.AddHandler(_E.M2U_STAFF_FLUSHUI,    StaffMainWindow.OnFlushUI,      StaffMainWindow,    StaffMainWindow)
    LuaEventManager.AddHandler(_E.M2U_STAFF_TRAIN,      StaffMainWindow.OnStaffTrain,   StaffMainWindow,    StaffMainWindow)
    LuaEventManager.AddHandler(_E.M2U_STAFF_UPGRADE,    StaffMainWindow.OnStaffUpgrade, StaffMainWindow,    StaffMainWindow)
end

function StaffMainWindow.Init(is_fire_mode)
    P.FireMode  = is_fire_mode
    P.PageView  = StaffMainWindow.PARAMS.ScrollView:GetComponent("PageView")

    StaffMainWindow.InitStaffItems()
    -- StaffMainWindow.InitCharacter()
    StaffMainWindow.InitAttributes()
    StaffMainWindow.FlushUI()
end

function StaffMainWindow.InitStaffItems(order)
    P.StaffItems:Each(function(item)
        destroy(item.GO)
    end)
    P.StaffItems:Clear()

    if PageViewCounter ~= nil then
        StopCoroutine(PageViewCounter)
        PageViewCounter = nil
    end

    local staff_array   = Controller.Staff.Staffs()

    for i = 1, staff_array:Count() do
       local staff  = staff_array:Get(i)

       local item   = UI.Manager:LoadItem(_C.UI.ITEM.STAFF, StaffMainWindow.PARAMS.Content)
       item:Init(staff)
       P.StaffItems:Add(item)

       UISimpleEventListener.PGet(item.GO,  item).onClick_P = function()
            StaffMainWindow.ShowItemLight(false)
            StaffMainWindow.PageTo(i)
       end
    end

    PageViewCounter = StartCoroutine(function()   
        WaitForEndOfFrame()
        P.PageView:Init(order or 0, function(index)
            Controller.Staff.SetIndex(index + 1)
        end, function()
            StaffMainWindow.ShowItemLight(true, Controller.Staff.Current())
        end)
    end)

end

function StaffMainWindow.PageTo(index)
    P.PageView:pageTo(index - 1)
end

function StaffMainWindow.SwitchLeft()
    local index     = Controller.Staff.Index()
    local count     = Controller.Staff.Staffs():Count()

    if index > 1 then
        index       = index - 1
    end

    StaffMainWindow.ShowItemLight(false)
    StaffMainWindow.PageTo(index)
end

function StaffMainWindow.SwitchRight()
    local index     = Controller.Staff.Index()
    local count     = Controller.Staff.Staffs():Count()

    if index < count then
        index       = index + 1
    end
    StaffMainWindow.ShowItemLight(false)
    StaffMainWindow.PageTo(index)
end


-- function StaffMainWindow.InitCharacter()
--     local entity = AssetManager:LoadSync("Skeleton/10000")
--     entity.transform:SetParent(StaffMainWindow.PARAMS.CharacterPivot.transform)
--     entity.transform.localScale      = Vector3.New(90, 90, 90)
--     entity.transform.localPosition   = Vector3.zero

--     local avatar     = entity.transform:GetComponent("Avatar")
--     avatar:SetOrder(1005)

--     P.Entity    = entity

-- end

function StaffMainWindow.Character_QingZhu()
    local animator  = P.Entity.transform:GetComponent("Animator")
    animator:Play("QingZhu")
end

function StaffMainWindow.InitAttributes()
    local staff     = Controller.Staff.Current()

    for i = _C.ATTRIBUTE.PLAN , _C.ATTRIBUTE.MUSIC  do
        P.Attributes[i].Count.text    = staff:GetAttribute(i)
    end
end

function StaffMainWindow.ShowItemLight(flag, staff)
    if flag == true then
        if P.LightItem == nil then
            local item  = UI.Manager:LoadItem(_C.UI.ITEM.STAFFLIGHT, StaffMainWindow.PARAMS.LightPivot)
            item:Init(staff)

            P.LightItem = item
        end
    end

    if P.LightItem == nil then
        return
    end

    P.LightItem.GO:SetActive(flag)
end

function StaffMainWindow.FlushUI()
    local staff     = Controller.Staff.Current()
    local job       = staff.Job
    StaffMainWindow.PARAMS.Name.text    = staff.Name
    StaffMainWindow.PARAMS.Job.text     = job.Name
    StaffMainWindow.PARAMS.Salary.text  = SetShowNumber(staff:GetSalary()) .. "/月"
    StaffMainWindow.PARAMS.Skill.text   = staff:GetSkillDescription()

    StaffMainWindow.PARAMS.SalaryUp:SetActive(false)
    StaffMainWindow.PARAMS.JobUp:SetActive(false)

    for k, temp in pairs(P.Attributes) do
        temp.Count.text = "<#80E0F8>" .. staff:GetAttribute(k) .. "</color>"
    end

    StaffMainWindow.PARAMS.ArrowLeft:SetActive(Controller.Staff.Staffs():Count() > 1)
    StaffMainWindow.PARAMS.ArrowRight:SetActive(Controller.Staff.Staffs():Count() > 1)



    if P.FireMode == true then
        StaffMainWindow.PARAMS.BtnFire:SetActive(false)
        StaffMainWindow.PARAMS.BtnTrain:SetActive(false)
        StaffMainWindow.PARAMS.BtnUpgrade:SetActive(false)

        StaffMainWindow.PARAMS.BtnForceFire:SetActive(true)
    else
        StaffMainWindow.PARAMS.BtnFire:SetActive(Controller.Data.Account():GetCompany():GetStaffs():Count() > 1)
        StaffMainWindow.PARAMS.BtnUpgrade:SetActive(job:IsMax() == false)

    end

    local index     = Controller.Staff.Index()
    P.StaffItems:Each(function(item, idx)
        if index == idx then
            item:TurnGray(false)
        else
            item:TurnGray(true, math.abs(index - idx))
        end
    end)
end

function StaffMainWindow.OnFlushUI(pself, event)
    StaffMainWindow.FlushUI()
end


function StaffMainWindow.OnAttributeChange(display_info)
    for _,c in ipairs(CounterList) do
        UpdateManager.UnRegisterTimer(c)
    end
    CounterList = {}

    local up        = 0
    for _,cfg in ipairs(display_info) do
        cfg.Text        = P.Attributes[cfg.Type].Count
        cfg.Text.text   = cfg.O
        up          = math.max(up, math.abs(cfg.N - cfg.O))
    end

    local step      = 0.6 / up
    local Times     = 0
    
    table.insert(CounterList,  Logic.TimeCounter.Register(1.5, nil,
        function(delta_time)
            Times       = Times + delta_time
            if Times >= step then
                Times   = Times - step

                for _,cfg in ipairs(display_info) do
                    if cfg.O < cfg.N then
                        cfg.O           = cfg.O + 1
                        cfg.Text.text   = _C.COLOR.GREEN .. cfg.O
                    end
                end
            end
        end,
        function()
            StaffMainWindow.FlushUI()
        end)
    )
       
    -- Logic.TimeCounter.Register(0.5, nil, nil, function()
    --     Display.EffectManager.Add("Prefab/Effects/fx_levelbar_upgrade", StaffMainWindow.PARAMS.UpgradePivot, Vector3.zero)    
    -- end)
    
    
end

function StaffMainWindow.OnStaffTrain(pself, event, staff , display_info, train_data)
    if Controller.Staff.Current() ~= staff then
        return
    end

    if #display_info == 0 then
        Controller.System.FlyTip(string.format("无法从%s学到更多的知识了", train_data.Name))
        return
    end
    Logic.MusicPlayer.PlaySound(SOUND.TRAIN)

    StaffMainWindow.PARAMS.SalaryUp:SetActive(true) 
    StaffMainWindow.OnAttributeChange(display_info)

end

function StaffMainWindow.OnStaffUpgrade(pself, event, staff, display_info)
    if Controller.Staff.Current() ~= staff then
        return
    end

    Logic.MusicPlayer.PlaySound(SOUND.UPGRADE)

    StaffMainWindow.PARAMS.SalaryUp:SetActive(true)
    StaffMainWindow.PARAMS.JobUp:SetActive(true)

    StaffMainWindow.OnAttributeChange(display_info)

    -- StaffMainWindow.Character_QingZhu()
end


function StaffMainWindow.OnDestroy()
    P   = {}

    for _,c in ipairs(CounterList) do
        UpdateManager.UnRegisterTimer(c)
    end
    CounterList = {}

    if PageViewCounter ~= nil then
        StopCoroutine(PageViewCounter)
        PageViewCounter = nil
    end

    LuaEventManager.DelHandler(_E.M2U_STAFF_FLUSHUI,    StaffMainWindow.OnFlushUI,      StaffMainWindow)
    LuaEventManager.DelHandler(_E.M2U_STAFF_TRAIN,      StaffMainWindow.OnStaffTrain,   StaffMainWindow)
    LuaEventManager.DelHandler(_E.M2U_STAFF_UPGRADE,    StaffMainWindow.OnStaffUpgrade, StaffMainWindow)
end



return StaffMainWindow