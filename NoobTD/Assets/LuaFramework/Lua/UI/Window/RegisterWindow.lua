
local RegisterWindow = {}
setmetatable(RegisterWindow, {__index = WindowBase})

local P     = {}


function RegisterWindow.Awake(items)
    RegisterWindow.PARAMS.BtnHire           = items["BtnHire"]
    RegisterWindow.PARAMS.BtnRandom         = items["BtnRandom"]
    RegisterWindow.PARAMS.DiceTime          = items["DiceTime"]
    RegisterWindow.PARAMS.LeftArrow         = items["LeftArrow"]
    RegisterWindow.PARAMS.RightArrow        = items["RightArrow"]

    RegisterWindow.PARAMS.SK                = items["SK"]
    RegisterWindow.PARAMS.Skill             = items["Skill"]

    RegisterWindow.PARAMS.Name              = items["Name"]:GetComponent("TMP_InputField")
    RegisterWindow.PARAMS.Job               = items["Job"]
    RegisterWindow.PARAMS.Salary            = items["Salary"]
    RegisterWindow.PARAMS.AttributePivot    = items["AttributePivot"]

    P.Attributes    = {}
    P.Animation     = RegisterWindow.GO:GetComponent("Animation")

    UIEventListener.PGet(RegisterWindow.PARAMS.BtnHire,   RegisterWindow).onClick_P = function()
        Logic.GameEnter.EnterCompany()
    end

    UIEventListener.PGet(RegisterWindow.PARAMS.BtnRandom,   RegisterWindow).onClick_P = function()
        if Logic.GameEnter.RandomStaff(P.Staff)  then
            Logic.MusicPlayer.PlaySound(SOUND.DICE)
            RegisterWindow.FlushUI(P.Staff)


            P.Animation:Play("ClickDice")
        end
    end

    UIEventListener.PGet(RegisterWindow.PARAMS.LeftArrow,   RegisterWindow).onClick_P = function()
        Controller.Data.Account():SwitchOJob(true)
        Logic.GameEnter.RandomStaff(P.Staff, true)

        RegisterWindow.FlushUI(P.Staff)
    end

    UIEventListener.PGet(RegisterWindow.PARAMS.RightArrow,   RegisterWindow).onClick_P = function()
        Controller.Data.Account():SwitchOJob(false)
        Logic.GameEnter.RandomStaff(P.Staff, true)

        RegisterWindow.FlushUI(P.Staff)
    end

    LuaEventManager.AddHandler(_E.INPUTFIELD_ENDEDIT,       RegisterWindow.OnNameEndEdit, RegisterWindow, RegisterWindow)
end

function RegisterWindow.Init(staff)
    P.Staff     = staff

    RegisterWindow.InitAttributes(staff)
    RegisterWindow.FlushUI(staff)
end

function RegisterWindow.InitAttributes(staff)
    for i = _C.ATTRIBUTE.PLAN , _C.ATTRIBUTE.MUSIC  do
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.ATTRIBUTE, RegisterWindow.PARAMS.AttributePivot)
        item:Init(i, 0)
        item:ShowBottom(true)
        P.Attributes[i] = item
    end
end

function RegisterWindow.FlushUI(staff)
    local job       = staff.Job

    RegisterWindow.PARAMS.Name.text    = staff.Name
    RegisterWindow.PARAMS.Job.text     = job.Name
    RegisterWindow.PARAMS.Salary.text  = SetShowNumber(staff:GetSalary()) .. "/月"

    RegisterWindow.PARAMS.DiceTime.text = Controller.Data.Account().FreeDice

    for k, item in pairs(P.Attributes) do
        item:SetScore(staff:GetAttribute(k))
    end

    
    RegisterWindow.PARAMS.SK:SetActive(staff.Skills:Count() > 0)
    RegisterWindow.PARAMS.Skill.text   = staff:GetSkillDescription()

end


function RegisterWindow.OnNameEndEdit(pself, eventType, entity)
    if entity ~= RegisterWindow.PARAMS.Name then return end

    if RegisterWindow.PARAMS.Name.text == "" then
        RegisterWindow.PARAMS.Name.text = P.Staff.Name
    else
        P.Staff.Name    = RegisterWindow.PARAMS.Name.text
    end
end


function RegisterWindow.OnDestroy()

    P   = {}

    LuaEventManager.DelHandler(_E.INPUTFIELD_ENDEDIT,       RegisterWindow.OnNameEndEdit, RegisterWindow)
end



return RegisterWindow