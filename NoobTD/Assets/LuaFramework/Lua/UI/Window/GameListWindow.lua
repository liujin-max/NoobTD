
local GameListWindow = {}
setmetatable(GameListWindow, {__index = WindowBase})

local P     = {}



function GameListWindow.Awake(items)
    GameListWindow.PARAMS.Title             = items["Title"]
    GameListWindow.PARAMS.ConsoleName       = items["ConsoleName"]
    GameListWindow.PARAMS.ScorePivot        = items["ScorePivot"]

    GameListWindow.PARAMS.GameName          = items["GameName"]
    GameListWindow.PARAMS.GameType          = items["GameType"]
    GameListWindow.PARAMS.GameTheme         = items["GameTheme"]
    GameListWindow.PARAMS.GameSale          = items["GameSale"]
    GameListWindow.PARAMS.Date              = items["Date"]
    GameListWindow.PARAMS.P4Name            = items["P4Name"]
    GameListWindow.PARAMS.TagNetwork        = items["TagNetwork"]
    GameListWindow.PARAMS.AttributePivot    = items["AttributePivot"]
    
    GameListWindow.PARAMS.ArrowLeft         = items["ArrowLeft"]
    GameListWindow.PARAMS.ArrowRight        = items["ArrowRight"]
    GameListWindow.PARAMS.BtnConfirm        = items["BtnConfirm"]
    GameListWindow.PARAMS.BtnClose          = items["BtnClose"]
    GameListWindow.PARAMS.Mask              = items["Mask"]


    P.Attributes    = {}


    UIEventListener.PGet(GameListWindow.PARAMS.Mask,          GameListWindow).onClick_P = function()
        UI.GameListWindow.ProgressHide(UI.GameListWindow,_C.UI.WINDOW.GAMELIST)
    end

    UIEventListener.PGet(GameListWindow.PARAMS.BtnClose,      GameListWindow).onClick_P = function()
        UI.GameListWindow.ProgressHide(UI.GameListWindow,_C.UI.WINDOW.GAMELIST)
    end

    UIEventListener.PGet(GameListWindow.PARAMS.ArrowLeft,     GameListWindow).onClick_P = GameListWindow.SwitchLeft

    UIEventListener.PGet(GameListWindow.PARAMS.ArrowRight,    GameListWindow).onClick_P = GameListWindow.SwitchRight
end

function GameListWindow.Init()
    P.GameArray = Controller.Data.Account().History:GetGames()
    P.Index     = P.GameArray:Count()
    P.Game      = P.GameArray:Get(P.Index)

    GameListWindow.InitAttributes()
    GameListWindow.FlushUI()
end

function GameListWindow.InitAttributes()
    for i = _C.ATTRIBUTE.PLAN , _C.ATTRIBUTE.MUSIC  do
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.ATTRIBUTE, GameListWindow.PARAMS.AttributePivot)
        item:Init(i, 0)

        P.Attributes[i] = item
    end
end

function GameListWindow.FlushUI()
    local game          = P.Game
    local game_count    = P.GameArray:Count()

    GameListWindow.PARAMS.Title.text        = "历代作品 " .. "(" .. P.Index .. "/" .. game_count .. ")"

    GameListWindow.PARAMS.ConsoleName.text  = game.GameConsole.Name
    GameListWindow.PARAMS.GameName.text     = game.Name
    GameListWindow.PARAMS.GameType.text     = game.Type.Name
    GameListWindow.PARAMS.GameTheme.text    = game.Theme.Name
    GameListWindow.PARAMS.Date.text         = game.GameSellLogic ~= nil and game.GameSellLogic:GetOfferingDateText() or "暂无"

    GameListWindow.PARAMS.TagNetwork:SetActive(game:IsNetwork())
    if game:IsNetwork() == true then
        GameListWindow.PARAMS.P4Name.text   = "销售金额"
        GameListWindow.PARAMS.GameSale.text = game.GameSellLogic ~= nil and SetShowNumber(game.GameSellLogic:GetSaleMoney()) or "暂无"
    else
        GameListWindow.PARAMS.P4Name.text   = "游戏销量"
        GameListWindow.PARAMS.GameSale.text = game.GameSellLogic ~= nil and SetShowNumber(game.GameSellLogic:GetSalesVolume()) or "暂无"
    end

    for k, item in pairs(P.Attributes) do
        local score     = game:GetAttribute(k)
        item:SetScore(score)
    end

    if P.ScoreItem == nil then
        P.ScoreItem  = UI.Manager:LoadItem(_C.UI.ITEM.GAMESCORE, GameListWindow.PARAMS.ScorePivot)
    end
    P.ScoreItem:Init(game:GetAvgScore())

    GameListWindow.PARAMS.ArrowLeft:SetActive(game_count > 1)
    GameListWindow.PARAMS.ArrowRight:SetActive(game_count > 1)
end

function GameListWindow.SwitchLeft()
    if P.Index == 1 then
        P.Index = P.GameArray:Count()
    else
        P.Index = P.Index - 1
    end

    P.Game      = P.GameArray:Get(P.Index)

    UI.GameListWindow.FlushUI()
end

function GameListWindow.SwitchRight()
    if P.Index == P.GameArray:Count() then
        P.Index = 1
    else
        P.Index = P.Index + 1
    end

    P.Game      = P.GameArray:Get(P.Index)

    UI.GameListWindow.FlushUI()
end



function GameListWindow.OnDestroy()
    P   = {}
end



return GameListWindow