
local GameTopTenWindow = {}
setmetatable(GameTopTenWindow, {__index = WindowBase})

local P     = {}

local COLORS    = 
{
    Color.New(255 / 255, 0 / 255, 0 / 255, 1),
    Color.New(255 / 255, 104 / 255, 0 / 255, 1),
    Color.New(255 / 255, 218 / 255, 0 / 255, 1),
    Color.New(255 / 255, 0 / 255, 130 / 255, 1),
    Color.New(159 / 255, 0 / 255, 255 / 255, 1),
    Color.New(127 / 255, 255 / 255, 0 / 255, 1),
    Color.New(14 / 255, 152 / 255, 103 / 255, 1),
    Color.New(0 / 255, 207 / 255, 255 / 255, 1),
    Color.New(0 / 255, 255 / 255, 175 / 255, 1),
    Color.New(0 / 255, 30 / 255, 255 / 255, 1),
}


function GameTopTenWindow.Awake(items)
    GameTopTenWindow.PARAMS.Mask        = items["Mask"]

    GameTopTenWindow.PARAMS.NameList    = items["NameList"]
    GameTopTenWindow.PARAMS.ChartPivot  = items["ChartPivot"]


    UIEventListener.PGet(GameTopTenWindow.PARAMS.Mask,  GameTopTenWindow).onClick_P = function()
        UI.GameTopTenWindow.ProgressHide(UI.GameTopTenWindow,_C.UI.WINDOW.GAMETOPTEN)
    end
end

function GameTopTenWindow.Init()
    local games     = Controller.Data.Account().History:GetGames()
    local tops      = Class.new(Array)

    for i = 1, games:Count() do
        local g     = games:Get(i)
        if g:IsNetwork() == false and g.GameSellLogic ~= nil then
            local count = g.GameSellLogic:GetSalesVolume()

            tops:Add({Game = g, Count = count})
        end
    end
    tops:SortBy("Count", true)

    GameTopTenWindow.InitNames(tops)
    GameTopTenWindow.InitChart(tops)
end

function GameTopTenWindow.InitNames(games)
    for i = 1, games:Count() do
        if i <= 10 then
            local data = games:Get(i)
            if data == nil then
                break
            end

            local item  = UI.Manager:LoadItem(_C.UI.ITEM.CHARTNAME, GameTopTenWindow.PARAMS.NameList)
            item:Init(data.Game, COLORS[i])
        else
            break
        end
    end
end

function GameTopTenWindow.InitChart(games)
    local fitter_games  = {}

    local total_count   = 0
    for i = 1, games:Count() do
        if i <= 10 then
            local data = games:Get(i)
            if data == nil then
                break
            end

            total_count     = total_count + data.Count
            table.insert(fitter_games, data)
        else
            break
        end
    end

    local last_percent  = 0
    for _,data in ipairs(fitter_games) do
        data.Percent    = data.Count / total_count
        data.Angle      = last_percent
        last_percent    = last_percent + data.Percent
    end

    for i = 1 , #fitter_games do
        local data  = fitter_games[i]
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.CHARTCIRCLE, GameTopTenWindow.PARAMS.ChartPivot)
        item.GO.transform.localScale        = Vector3.New(1.8 - i / 10, 1.8 - i / 10, 1)
        item.GO.transform.localEulerAngles  = Vector3.New(0, 0, -360 * data.Angle)
        item:Init(data.Game, data.Percent, COLORS[i])
    end
end


function GameTopTenWindow.OnDestroy()
    P   = {}

end



return GameTopTenWindow