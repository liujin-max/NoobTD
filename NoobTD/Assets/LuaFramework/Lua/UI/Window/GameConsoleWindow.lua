
local GameConsoleWindow = {}
setmetatable(GameConsoleWindow, {__index = WindowBase})

local P     = {}


function GameConsoleWindow.Awake(items)
    GameConsoleWindow.PARAMS.Mask           = items["Mask"]
    GameConsoleWindow.PARAMS.BtnClose       = items["BtnClose"]
    GameConsoleWindow.PARAMS.BtnConfirm     = items["BtnConfirm"]

    GameConsoleWindow.PARAMS.ArrowLeft      = items["ArrowLeft"]
    GameConsoleWindow.PARAMS.ArrowRight     = items["ArrowRight"]

    GameConsoleWindow.PARAMS.ConsoleName    = items["ConsoleName"]
    GameConsoleWindow.PARAMS.CompanyName    = items["CompanyName"]
    GameConsoleWindow.PARAMS.ShareRate      = items["ShareRate"]
    GameConsoleWindow.PARAMS.Date           = items["Date"]
    GameConsoleWindow.PARAMS.Times          = items["Times"]
    GameConsoleWindow.PARAMS.Cost           = items["Cost"]
    GameConsoleWindow.PARAMS.PointContent   = items["PointContent"]


    UIEventListener.PGet(GameConsoleWindow.PARAMS.ArrowLeft,    GameConsoleWindow).onClick_P = GameConsoleWindow.SwitchLeft
    UIEventListener.PGet(GameConsoleWindow.PARAMS.ArrowRight,   GameConsoleWindow).onClick_P = GameConsoleWindow.SwitchRight

    UIEventListener.PGet(GameConsoleWindow.PARAMS.Mask,    GameConsoleWindow).onClick_P = function()
        UI.GameConsoleWindow.ProgressHide(UI.GameConsoleWindow,_C.UI.WINDOW.GAMECONSOLE)
    end

    UIEventListener.PGet(GameConsoleWindow.PARAMS.BtnClose,    GameConsoleWindow).onClick_P = function()
        UI.GameConsoleWindow.ProgressHide(UI.GameConsoleWindow,_C.UI.WINDOW.GAMECONSOLE)
    end
    
    UIEventListener.PGet(GameConsoleWindow.PARAMS.BtnConfirm,    GameConsoleWindow).onClick_P = function()
        Controller.Main.SelectGameConsole(P.Console)

        UI.GameConsoleWindow.ProgressHide(UI.GameConsoleWindow,_C.UI.WINDOW.GAMECONSOLE)
    end
end

function GameConsoleWindow.Init()
    P.Consoles  = Controller.Data.GameMarket():GetConsoles()
    P.Console   = Controller.Main.GameConsole()
    P.Index     = nil
    P.Points    = Class.new(Array)

    if P.Console == nil then
        P.Index     = 1
        P.Console   = P.Consoles:Get(P.Index)
    else
        P.Index     = P.Consoles:IndexOf(P.Console) or 1
    end

    GameConsoleWindow.InitPoints()

    GameConsoleWindow.FlushUI()
end

function GameConsoleWindow.FlushUI()
    GameConsoleWindow.PARAMS.ConsoleName.text   = P.Console.Name
    GameConsoleWindow.PARAMS.ShareRate.text     = P.Console:GetShareRate() .. "%"
    GameConsoleWindow.PARAMS.Times.text         = P.Console:GetBuildTimes() .. "次"
    GameConsoleWindow.PARAMS.Cost.text          = string.format(_C.MESSAGE.FORMATEPRICE, SetShowNumber(P.Console:GetCost()))

    local unlock_date   = P.Console:GetUnlockTime()
    if unlock_date ~= nil then
        GameConsoleWindow.PARAMS.Date.text          = Controller.Data.Date().DateString(unlock_date)
    else
        GameConsoleWindow.PARAMS.Date.text          = Controller.Data.Date().DateString(0)
    end

    if P.Console.Belong == nil then
        GameConsoleWindow.PARAMS.CompanyName.text   = "未知"
    else
        local cfg   = Table.Get(Table.CompanyTable, P.Console.Belong)
        if cfg.IsMy == 1 then
            GameConsoleWindow.PARAMS.CompanyName.text   = Controller.Data.Account():GetCompany():GetName()
        else
            GameConsoleWindow.PARAMS.CompanyName.text   = cfg.Name
        end
        
    end

    P.Points:Each(function(item, idx)
        item:Show(idx == P.Index)
    end)
end

function GameConsoleWindow.InitPoints()
    for i = 1, P.Consoles:Count() do
       local item   = UI.Manager:LoadPointItem(GameConsoleWindow.PARAMS.PointContent) 
       item:Show(false)
       P.Points:Add(item)
    end
end

function GameConsoleWindow.SwitchLeft()
    if P.Index == 1 then
        P.Index     = P.Consoles:Count()
    else
        P.Index     = P.Index - 1
    end
    P.Console   = P.Consoles:Get(P.Index)

    GameConsoleWindow.FlushUI()
end

function GameConsoleWindow.SwitchRight()
    if P.Index == P.Consoles:Count() then
        P.Index     = 1
    else
        P.Index     = P.Index + 1
    end

    P.Console   = P.Consoles:Get(P.Index)

    GameConsoleWindow.FlushUI()
end






function GameConsoleWindow.OnDestroy()
    P.Points:Each(function(item)
        UI.Manager:UnloadPointItem(item)
    end)
    
    P   = {}
end



return GameConsoleWindow