--GameSeriesWindow: 网络控制台

local GameSeriesWindow = {}
setmetatable(GameSeriesWindow, {__index = WindowBase})

local P     = {}

local function NewSeriesItem(idx)
    local item  = P.SeriesItems:Get(idx)
    if item == nil then
        item    = UI.Manager:LoadItem(_C.UI.ITEM.GAMESERIES,    GameSeriesWindow.PARAMS.SeriesContent)
        P.SeriesItems:Add(item)
    end
    item.GO:SetActive(true)
    return item
end

function GameSeriesWindow.Awake(items)
    GameSeriesWindow.PARAMS.Mask            = items["Mask"]
    GameSeriesWindow.PARAMS.BtnClose        = items["BtnClose"]

    GameSeriesWindow.PARAMS.TabContent      = items["TabContent"]
    GameSeriesWindow.PARAMS.SeriesContent   = items["SeriesContent"]
    GameSeriesWindow.PARAMS.SalePivot       = items["SalePivot"]
    GameSeriesWindow.PARAMS.SalesVolume     = items["SalesVolume"]
    GameSeriesWindow.PARAMS.SeriesType      = items["SeriesType"]


    P.SeriesItems   = Class.new(Array)

    UIEventListener.PGet(GameSeriesWindow.PARAMS.Mask,  GameSeriesWindow).onClick_P     = function()
        UI.GameSeriesWindow.ProgressHide(UI.GameSeriesWindow,_C.UI.WINDOW.GAMESERIES)
    end

    UIEventListener.PGet(GameSeriesWindow.PARAMS.BtnClose,  GameSeriesWindow).onClick_P     = function()
        UI.GameSeriesWindow.ProgressHide(UI.GameSeriesWindow,_C.UI.WINDOW.GAMESERIES)
    end
end

function GameSeriesWindow.Init()
    GameSeriesWindow.PARAMS.SalePivot:SetActive(false)

    GameSeriesWindow.InitTabs()
end

function GameSeriesWindow.InitTabs()
    local array     = Controller.GameSeries.SeriesArray()

    for i = 1, array:Count() do
        local series= array:Get(i)

        local item  = UI.Manager:LoadItem(_C.UI.ITEM.GAMESERIESTAB, GameSeriesWindow.PARAMS.TabContent)
        item:Init(series)

        if i == 1 then
            GameSeriesWindow.SelectTab(item)
        end

        UISimpleEventListener.PGet(item.GO, item).onClick_P = function()
            if P.TabItem == item then return end

            GameSeriesWindow.SelectTab(item)
        end
    end
end

function GameSeriesWindow.SelectTab(tab_item)
    if P.TabItem ~= nil then
        P.TabItem:Select(false)
    end

    P.TabItem = tab_item
    P.TabItem:Select(true)

    GameSeriesWindow.FlushItems(tab_item.GameSeries)
    GameSeriesWindow.FlushUI(tab_item.GameSeries)
end


function GameSeriesWindow.FlushItems(series)
    P.SeriesItems:Each(function(item)
        item.GO:SetActive(false)        
    end)

    local idx       = 1
    local games     = series:GetGames()
    for i = games:Count(), 1, -1 do
        local game  = games:Get(i)
        local item  = NewSeriesItem(idx)
        item:Init(game)

        idx = idx + 1
    end
end

function GameSeriesWindow.FlushUI(series)
    GameSeriesWindow.PARAMS.SalePivot:SetActive(true)

    local game  = series:GetGames():First()
    local type  = game.Type
    local theme = game.Theme
    GameSeriesWindow.PARAMS.SeriesType.text = type.Name .. "、" .. theme.Name
    GameSeriesWindow.PARAMS.SalesVolume.text= SetShowNumber(series:GetSalesVolume()) .. "套"
end

function GameSeriesWindow.OnDestroy()
    P     = {}
end

return GameSeriesWindow