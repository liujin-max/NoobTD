
local RegisterCompanyWindow = {}
setmetatable(RegisterCompanyWindow, {__index = WindowBase})

local P     = {}


function RegisterCompanyWindow.Awake(items)
    RegisterCompanyWindow.PARAMS.BtnConfirm     = items["BtnConfirm"]
    RegisterCompanyWindow.PARAMS.Name           = items["Name"]:GetComponent("TMP_InputField")


    UIEventListener.PGet(RegisterCompanyWindow.PARAMS.BtnConfirm,   RegisterCompanyWindow).onClick_P = function()
        if RegisterCompanyWindow.PARAMS.Name.text == "" then
            return
        end

        Controller.Data.Account().Company:SetName(RegisterCompanyWindow.PARAMS.Name.text)

        Logic.GameEnter.Enter()
    end

    LuaEventManager.AddHandler(_E.INPUTFIELD_ENDEDIT,       RegisterCompanyWindow.OnNameEndEdit, RegisterCompanyWindow, RegisterCompanyWindow)
end

function RegisterCompanyWindow.Init()
    RegisterCompanyWindow.FlushUI()
end



function RegisterCompanyWindow.FlushUI()

    RegisterCompanyWindow.PARAMS.Name.text    = Controller.Data.Account().Company.Name
end

function RegisterCompanyWindow.OnNameEndEdit(pself, eventType, entity)
    if entity ~= RegisterCompanyWindow.PARAMS.Name then return end

    if RegisterCompanyWindow.PARAMS.Name.text == "" then
        RegisterCompanyWindow.PARAMS.Name.text = Controller.Data.Account().Company.Name
    end
end

function RegisterCompanyWindow.OnDestroy()

    P   = {}

    LuaEventManager.DelHandler(_E.INPUTFIELD_ENDEDIT,       RegisterCompanyWindow.OnNameEndEdit, RegisterCompanyWindow)
end



return RegisterCompanyWindow