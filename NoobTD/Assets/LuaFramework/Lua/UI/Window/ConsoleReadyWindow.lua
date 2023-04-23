
local ConsoleReadyWindow = {}
setmetatable(ConsoleReadyWindow, {__index = WindowBase})

local P     = {}



function ConsoleReadyWindow.Awake(items)
    ConsoleReadyWindow.PARAMS.NameIF        = items["Name"]:GetComponent("TMP_InputField")
    ConsoleReadyWindow.PARAMS.CPU           = items["CPU"]
    ConsoleReadyWindow.PARAMS.GPU           = items["GPU"]
    ConsoleReadyWindow.PARAMS.RAM           = items["RAM"]
    ConsoleReadyWindow.PARAMS.AttributePivot = items["AttributePivot"]
    
    ConsoleReadyWindow.PARAMS.BtnSell      = items["BtnSell"]


    P.Attributes    = {}

    UIEventListener.PGet(ConsoleReadyWindow.PARAMS.BtnSell,    ConsoleReadyWindow).onClick_P = function()
        P.Console:SetName(ConsoleReadyWindow.PARAMS.NameIF.text)

        UI.ConsoleReadyWindow.ProgressHide(UI.ConsoleReadyWindow,_C.UI.WINDOW.CONSOLEREADY)
    end
end

function ConsoleReadyWindow.Init(console)
    P.Console      = console

    ConsoleReadyWindow.InitAttributes(console)
    ConsoleReadyWindow.FlushUI(console)
end

function ConsoleReadyWindow.InitAttributes(console)
    for i = _C.ATTRIBUTE.PLAN , _C.ATTRIBUTE.MUSIC  do
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.ATTRIBUTE, ConsoleReadyWindow.PARAMS.AttributePivot)
        item:Init(i, console:GetAttribute(i))

        P.Attributes[i] = item
    end
end

function ConsoleReadyWindow.FlushUI(console)
    ConsoleReadyWindow.PARAMS.NameIF.text   = console.Name

    ConsoleReadyWindow.PARAMS.CPU.text      = console.CPU.Name
    ConsoleReadyWindow.PARAMS.GPU.text      = console.GPU.Name
    ConsoleReadyWindow.PARAMS.RAM.text      = console.RAM.Name

    for k, item in pairs(P.Attributes) do
        local score     = console:GetAttribute(k)
        item:SetScore(score)
    end
end





function ConsoleReadyWindow.OnDestroy()
    P   = {}
end



return ConsoleReadyWindow