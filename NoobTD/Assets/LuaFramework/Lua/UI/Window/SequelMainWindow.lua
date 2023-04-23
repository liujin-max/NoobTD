
local SequelMainWindow = {}
setmetatable(SequelMainWindow, {__index = WindowBase})

local P     = {}


function SequelMainWindow.Awake(items)
    SequelMainWindow.PARAMS.Cost            = items["Cost"]
    SequelMainWindow.PARAMS.Console         = items["Console"]
    SequelMainWindow.PARAMS.Game            = items["Game"]

    SequelMainWindow.PARAMS.BtnConsole      = items["BtnConsole"]
    SequelMainWindow.PARAMS.BtnGame         = items["BtnGame"]

    SequelMainWindow.PARAMS.Mask            = items["Mask"]
    SequelMainWindow.PARAMS.BtnClose        = items["BtnClose"]
    SequelMainWindow.PARAMS.BtnConfirm      = items["BtnConfirm"]

   
    UIEventListener.PGet(SequelMainWindow.PARAMS.Mask,    SequelMainWindow).onClick_P = function()
        Controller.GameSequel.Dispose()
    end

    UIEventListener.PGet(SequelMainWindow.PARAMS.BtnClose,    SequelMainWindow).onClick_P = function()
        Controller.GameSequel.Dispose()
    end

    UIEventListener.PGet(SequelMainWindow.PARAMS.BtnConfirm,    SequelMainWindow).onClick_P = function()
        Controller.GameSequel.BuildSequel()
    end

    UIEventListener.PGet(SequelMainWindow.PARAMS.BtnConsole,    SequelMainWindow).onClick_P = function()
        UI.Manager:LoadUIWindow(_C.UI.WINDOW.GAMECONSOLE, UI.Manager.MAJOR)
        UI.GameConsoleWindow.Init()
    end

    UIEventListener.PGet(SequelMainWindow.PARAMS.BtnGame,    SequelMainWindow).onClick_P = function()
        UI.Manager:LoadUIWindow(_C.UI.WINDOW.GAMESEQUEL,    UI.Manager.MAJOR)
        UI.GameSequelWindow.Init()
    end


    LuaEventManager.AddHandler(_E.SEQUEL_WINDOW_FLUSH,          SequelMainWindow.OnFlushUI,   SequelMainWindow, SequelMainWindow)
end

function SequelMainWindow.Init()
    SequelMainWindow.FlushUI()
end

function SequelMainWindow.FlushUI()
    local game      = Controller.GameSequel.CurrentGame()
    local console   = Controller.Main.GameConsole()

    SequelMainWindow.PARAMS.Console.text    = console and console.Name or ""
    SequelMainWindow.PARAMS.Game.text       = game and game.Name or ""

    local cost      = Controller.Data.Menu():GetGameCost(console,   game ~= nil and game.Type or nil, game ~= nil and game.Theme or nil)

    if Controller.Data.Account():GetMoney() < cost then
        SequelMainWindow.PARAMS.Cost.text = _C.COLOR.RED .. SetShowNumber(cost) .. "</color>"
    else
        SequelMainWindow.PARAMS.Cost.text = _C.COLOR.BLACK .. SetShowNumber(cost)  .. "</color>"
    end

end




function SequelMainWindow.OnFlushUI(pself, event)
    SequelMainWindow.FlushUI()
end


function SequelMainWindow.OnDestroy()
    LuaEventManager.DelHandler(_E.SEQUEL_WINDOW_FLUSH,          SequelMainWindow.OnFlushUI,   SequelMainWindow)
end



return SequelMainWindow