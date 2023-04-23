
local GameScoreWindow = {}
setmetatable(GameScoreWindow, {__index = WindowBase})

local P     = {}

local CounterList   = {}

function GameScoreWindow.Awake(items)
    GameScoreWindow.PARAMS.Mask             = items["Mask"]
    GameScoreWindow.PARAMS.Touch            = items["Touch"]

    P.ItemPivots    = {}
    P.ItemPivots[_C.EVALUATOR.IOS]          = items["1"]
    P.ItemPivots[_C.EVALUATOR.TAP]          = items["2"]
    P.ItemPivots[_C.EVALUATOR.IGN]          = items["3"]
    P.ItemPivots[_C.EVALUATOR.PLAYER]       = items["4"]



    UIEventListener.PGet(GameScoreWindow.PARAMS.Touch,   GameScoreWindow).onClick_P = function()
        if P.Callback ~= nil then
            P.Callback()
        end
    end

end

function GameScoreWindow.Init(evaluator, call_back)
    P.Callback      = call_back
    P.Evaluator     = evaluator

    GameScoreWindow.InitScoreItems()
end

function GameScoreWindow.InitScoreItems()
    local array = Class.new(Array)

    local item  = UI.Manager:LoadItem(_C.UI.ITEM.GAMESCORELEFT, P.ItemPivots[_C.EVALUATOR.IOS].transform)
    item:Init(P.Evaluator:GetScore(_C.EVALUATOR.IOS), P.Evaluator:GetComment(_C.EVALUATOR.IOS))
    array:Add(item)

    local item  = UI.Manager:LoadItem(_C.UI.ITEM.GAMESCORERIGHT, P.ItemPivots[_C.EVALUATOR.TAP].transform)
    item:Init(P.Evaluator:GetScore(_C.EVALUATOR.TAP), P.Evaluator:GetComment(_C.EVALUATOR.TAP))
    array:Add(item)

    local item  = UI.Manager:LoadItem(_C.UI.ITEM.GAMESCORELEFT, P.ItemPivots[_C.EVALUATOR.IGN].transform)
    item:Init(P.Evaluator:GetScore(_C.EVALUATOR.IGN), P.Evaluator:GetComment(_C.EVALUATOR.IGN))
    array:Add(item)

    local item  = UI.Manager:LoadItem(_C.UI.ITEM.GAMESCORERIGHT, P.ItemPivots[_C.EVALUATOR.PLAYER].transform)
    item:Init(P.Evaluator:GetScore(_C.EVALUATOR.PLAYER), P.Evaluator:GetComment(_C.EVALUATOR.PLAYER))
    array:Add(item)

    local Index     = 1
    local Times     = 0

    GameScoreWindow.PARAMS.Touch:SetActive(false)
    table.insert(CounterList, Logic.TimeCounter.Register(11, function()
            local item  = array:Get(Index)
            item:Show()
            Index   = Index + 1
        end, 
        function(delta_time)
            Times   = Times + delta_time
            if Times >= 3 then
                Times   = Times - 3

                local item  = array:Get(Index)
                if item ~= nil then
                    item:Show()

                    Index   = Index + 1
                end
            end
        end,
        function()
            LuaEventManager.SendEvent(_E.ACHIEVE_TRIGGER, nil, _C.ACHIEVEMENT.TRIGGER.GAMESCORE, {})
            GameScoreWindow.PARAMS.Touch:SetActive(true)
        end
    ))
    
end


function GameScoreWindow.Update()

end



function GameScoreWindow.OnDestroy()
    for i,c in ipairs(CounterList) do
        UpdateManager.UnRegisterTimer(c)
    end
    CounterList = {}
end



return GameScoreWindow