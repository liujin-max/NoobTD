
local FactoryResultWindow = {}
setmetatable(FactoryResultWindow, {__index = WindowBase})

local P     = {}


function FactoryResultWindow.Awake(items)
    FactoryResultWindow.PARAMS.Mask         = items["Mask"]
    FactoryResultWindow.PARAMS.BtnFinish    = items["BtnFinish"]

    FactoryResultWindow.PARAMS.EffectPivot  = items["EffectPivot"]
    FactoryResultWindow.PARAMS.Content      = items["Content"]

  
    P.BarItems  = Class.new(Array)

    UIEventListener.PGet(FactoryResultWindow.PARAMS.BtnFinish,  FactoryResultWindow).onClick_P = function()
        Controller.Data.Factory():TransistFSM(_C.GAME.PROCESS.MADE)
    end


    UpdateManager.AddHandler(FactoryResultWindow)
end

function FactoryResultWindow.Init(game, type_level_data, theme_level_data)
    Logic.MusicPlayer.PlaySound(SOUND.VICTORY)

    FactoryResultWindow.InitExpBar(game, type_level_data, theme_level_data)

    
    P.Effect = Display.EffectManager.Add("Prefab/Effects/fx_confetti_explosion" , FactoryResultWindow.PARAMS.EffectPivot, Vector3.zero)
    P.Effect:Show(false)
    Logic.TimeCounter.Register(0.5, nil , nil, function()
        P.Effect:Show(true)
    end)

    FactoryResultWindow.PARAMS.BtnFinish:SetActive(false)
end

function FactoryResultWindow.InitExpBar(game, type_level_data, theme_level_data)
    local game_type     = game.Type
    local game_theme    = game.Theme

    if type_level_data ~= nil then
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.EXPBAR, FactoryResultWindow.PARAMS.Content)
        item:Init(game_type, type_level_data)
        P.BarItems:Add(item)
    end

    if theme_level_data ~= nil then
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.EXPBAR, FactoryResultWindow.PARAMS.Content)
        item:Init(game_theme, theme_level_data)
        P.BarItems:Add(item)
    end

end

function FactoryResultWindow.IsOver()
    for i = 1, P.BarItems:Count() do
        local item = P.BarItems:Get(i)
        if item.IsOver == false then
            return false
        end
    end
    return true
end

function FactoryResultWindow.FlushUI()
    P.BarItems:Each(function(item)
        item:FlushUI()
    end)
end

function FactoryResultWindow.Update()
    FactoryResultWindow.FlushUI()

    if FactoryResultWindow.IsOver() == true then
        FactoryResultWindow.PARAMS.BtnFinish:SetActive(true)
    end
end


function FactoryResultWindow.OnDestroy()
    P   = {}

    UpdateManager.DelHandler(FactoryResultWindow)
end



return FactoryResultWindow