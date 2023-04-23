
local GameMainWindow = {}
setmetatable(GameMainWindow, {__index = WindowBase})

local P     = {}


function GameMainWindow.Awake(items)
    GameMainWindow.PARAMS.GameConsole       = items["GameConsole"]
    GameMainWindow.PARAMS.GameType          = items["GameType"]
    GameMainWindow.PARAMS.GameTheme         = items["GameTheme"]
    GameMainWindow.PARAMS.Cost              = items["Cost"]
    GameMainWindow.PARAMS.Fitter            = items["Fitter"]
    GameMainWindow.PARAMS.Nature            = items["Nature"]

    GameMainWindow.PARAMS.BtnConsole        = items["BtnConsole"]
    GameMainWindow.PARAMS.BtnType           = items["BtnType"]
    GameMainWindow.PARAMS.BtnTheme          = items["BtnTheme"]

    GameMainWindow.PARAMS.Mask              = items["Mask"]
    GameMainWindow.PARAMS.BtnClose          = items["BtnClose"]
    GameMainWindow.PARAMS.BtnConfirm        = items["BtnConfirm"]

   
    UIEventListener.PGet(GameMainWindow.PARAMS.Mask,    GameMainWindow).onClick_P = function()
        Controller.Game.Dispose()
    end

    UIEventListener.PGet(GameMainWindow.PARAMS.BtnClose,    GameMainWindow).onClick_P = function()
        Controller.Game.Dispose()
    end

    UIEventListener.PGet(GameMainWindow.PARAMS.BtnConfirm,    GameMainWindow).onClick_P = function()
        Controller.Game.BuildGame()
    end

    UIEventListener.PGet(GameMainWindow.PARAMS.BtnConsole,    GameMainWindow).onClick_P = function()
        UI.Manager:LoadUIWindow(_C.UI.WINDOW.GAMECONSOLE, UI.Manager.MAJOR)
        UI.GameConsoleWindow.Init()
    end

    UIEventListener.PGet(GameMainWindow.PARAMS.BtnType,        GameMainWindow).onClick_P = function()
        UI.Manager:LoadUIWindow(_C.UI.WINDOW.GAMETYPE, UI.Manager.MAJOR)
        UI.GameTypeWindow.Init()
    end

    UIEventListener.PGet(GameMainWindow.PARAMS.BtnTheme,       GameMainWindow).onClick_P = function()
        UI.Manager:LoadUIWindow(_C.UI.WINDOW.GAMETHEME, UI.Manager.MAJOR)
        UI.GameThemeWindow.Init()
    end

    UIEventListener.PGet(GameMainWindow.PARAMS.Nature.gameObject,       GameMainWindow).onClick_P = function()
        Controller.Main.SwitchNature()

        GameMainWindow.PARAMS.Nature.text   = Controller.Main.GameNature() == _C.GAME.NATURE.NORMAL and "单机" or "网游"
    end

    LuaEventManager.AddHandler(_E.MAIN_WINDOW_FLUSH,        GameMainWindow.OnFlushUI,   GameMainWindow, GameMainWindow)
end

function GameMainWindow.Init()
    GameMainWindow.FlushUI()
end

function GameMainWindow.FlushUI()
    local console   = Controller.Main.GameConsole()
    local type      = Controller.Main.GameType()
    local theme     = Controller.Main.GameTheme()

    GameMainWindow.PARAMS.GameConsole.text  = console and console.Name or ""
    GameMainWindow.PARAMS.GameType.text     = type and type.Name or ""
    GameMainWindow.PARAMS.GameTheme.text    = theme and theme.Name or ""

    local cost      = 0 --console:GetCost() + type:GetCost() + theme:GetCost()
    if console ~= nil  then
        cost        = cost + console:GetCost()
    end

    if type ~= nil  then
        cost        = cost + type:GetCost()
    end

    if theme ~= nil  then
        cost        = cost + theme:GetCost()
    end

    if Controller.Data.Account():GetMoney() < cost then
        GameMainWindow.PARAMS.Cost.text = _C.COLOR.RED .. SetShowNumber(cost) .. "</color>"
    else
        GameMainWindow.PARAMS.Cost.text = _C.COLOR.NORMAL .. SetShowNumber(cost)  .. "</color>"
    end


    GameMainWindow.PARAMS.Fitter.gameObject:SetActive(false)
    if type ~= nil and theme ~= nil then
        local cfg   = Controller.Data.Menu():GetFetterDic(type, theme)
        if cfg ~= nil then
            GameMainWindow.PARAMS.Fitter.gameObject:SetActive(true)
            GameMainWindow.PARAMS.Fitter.text    = _C.COLOR.FETTER[cfg.ID] .. cfg.Name .. "</color>"
        end
    end
end




function GameMainWindow.OnFlushUI(pself, event)
    GameMainWindow.FlushUI()
end


function GameMainWindow.OnDestroy()
    LuaEventManager.DelHandler(_E.MAIN_WINDOW_FLUSH,        GameMainWindow.OnFlushUI,   GameMainWindow)
end



return GameMainWindow