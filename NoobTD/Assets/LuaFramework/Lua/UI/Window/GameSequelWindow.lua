
local GameSequelWindow = {}
setmetatable(GameSequelWindow, {__index = WindowBase})

local P     = {}



function GameSequelWindow.Awake(items)
    GameSequelWindow.PARAMS.Title           = items["Title"]
    GameSequelWindow.PARAMS.ConsoleName     = items["ConsoleName"]
    GameSequelWindow.PARAMS.ScorePivot      = items["ScorePivot"]

    GameSequelWindow.PARAMS.GameName        = items["GameName"]
    GameSequelWindow.PARAMS.GameType        = items["GameType"]
    GameSequelWindow.PARAMS.GameTheme       = items["GameTheme"]
    GameSequelWindow.PARAMS.GameSale        = items["GameSale"]
    GameSequelWindow.PARAMS.Date            = items["Date"]
    GameSequelWindow.PARAMS.AttributePivot  = items["AttributePivot"]
    
    GameSequelWindow.PARAMS.ArrowLeft       = items["ArrowLeft"]
    GameSequelWindow.PARAMS.ArrowRight      = items["ArrowRight"]
    GameSequelWindow.PARAMS.BtnConfirm      = items["BtnConfirm"]
    GameSequelWindow.PARAMS.BtnClose        = items["BtnClose"]
    GameSequelWindow.PARAMS.Mask            = items["Mask"]


    P.Attributes    = {}


    UIEventListener.PGet(GameSequelWindow.PARAMS.Mask,          GameSequelWindow).onClick_P = function()
        UI.GameSequelWindow.ProgressHide(UI.GameSequelWindow,_C.UI.WINDOW.GAMESEQUEL)
    end

    UIEventListener.PGet(GameSequelWindow.PARAMS.BtnClose,      GameSequelWindow).onClick_P = function()
        UI.GameSequelWindow.ProgressHide(UI.GameSequelWindow,_C.UI.WINDOW.GAMESEQUEL)
    end


    UIEventListener.PGet(GameSequelWindow.PARAMS.BtnConfirm,    GameSequelWindow).onClick_P = function()
        Controller.GameSequel.SetGame(P.Game)

        UI.GameSequelWindow.ProgressHide(UI.GameSequelWindow,_C.UI.WINDOW.GAMESEQUEL)
    end

    UIEventListener.PGet(GameSequelWindow.PARAMS.ArrowLeft,     GameSequelWindow).onClick_P = GameSequelWindow.SwitchLeft

    UIEventListener.PGet(GameSequelWindow.PARAMS.ArrowRight,    GameSequelWindow).onClick_P = GameSequelWindow.SwitchRight
end

function GameSequelWindow.Init()
    P.GameArray = Controller.GameSequel.GameArray()
    P.Index     = 1
    P.Game      = P.GameArray:Get(P.Index)

    GameSequelWindow.InitAttributes()
    GameSequelWindow.FlushUI()
end

function GameSequelWindow.InitAttributes()
    for i = _C.ATTRIBUTE.PLAN , _C.ATTRIBUTE.MUSIC  do
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.ATTRIBUTE, GameSequelWindow.PARAMS.AttributePivot)
        item:Init(i, 0)

        P.Attributes[i] = item
    end
end

function GameSequelWindow.FlushUI()
    local game          = P.Game
    local game_count    = P.GameArray:Count()

    GameSequelWindow.PARAMS.Title.text          = "游戏续作 " .. "(" .. P.Index .. "/" .. game_count .. ")"

    GameSequelWindow.PARAMS.ConsoleName.text    = game.GameConsole.Name
    GameSequelWindow.PARAMS.GameName.text       = game.Name
    GameSequelWindow.PARAMS.GameType.text       = game.Type.Name
    GameSequelWindow.PARAMS.GameTheme.text      = game.Theme.Name
    GameSequelWindow.PARAMS.GameSale.text       = SetShowNumber(game.GameSellLogic:GetSalesVolume())
    GameSequelWindow.PARAMS.Date.text           = game.GameSellLogic:GetOfferingDateText()

    for k, item in pairs(P.Attributes) do
        local score     = game:GetAttribute(k)
        item:SetScore(score)
    end

    if P.ScoreItem == nil then
        P.ScoreItem  = UI.Manager:LoadItem(_C.UI.ITEM.GAMESCORE, GameSequelWindow.PARAMS.ScorePivot)
    end
    P.ScoreItem:Init(game:GetAvgScore())

    GameSequelWindow.PARAMS.ArrowLeft:SetActive(game_count > 1)
    GameSequelWindow.PARAMS.ArrowRight:SetActive(game_count > 1)
end

function GameSequelWindow.SwitchLeft()
    if P.Index == 1 then
        P.Index = P.GameArray:Count()
    else
        P.Index = P.Index - 1
    end

    P.Game      = P.GameArray:Get(P.Index)

    UI.GameSequelWindow.FlushUI()
end

function GameSequelWindow.SwitchRight()
    if P.Index == P.GameArray:Count() then
        P.Index = 1
    else
        P.Index = P.Index + 1
    end

    P.Game      = P.GameArray:Get(P.Index)

    UI.GameSequelWindow.FlushUI()
end



function GameSequelWindow.OnDestroy()
    P   = {}
end



return GameSequelWindow