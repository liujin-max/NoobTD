
local GameTypeWindow = {}
setmetatable(GameTypeWindow, {__index = WindowBase})

local P     = {}


function GameTypeWindow.Awake(items)
    GameTypeWindow.PARAMS.Mask          = items["Mask"]
    GameTypeWindow.PARAMS.Content       = items["Content"]
    GameTypeWindow.PARAMS.BtnClose      = items["BtnClose"]

    UIEventListener.PGet(GameTypeWindow.PARAMS.Mask,        GameTypeWindow).onClick_P = GameTypeWindow.OnClose
    UIEventListener.PGet(GameTypeWindow.PARAMS.BtnClose,    GameTypeWindow).onClick_P = GameTypeWindow.OnClose
end

function GameTypeWindow.Init()
    GameTypeWindow.InitGameTypes()
end

function GameTypeWindow.InitGameTypes()
    local types  = Controller.Data.Menu():GetGameTypes()

    types:Each(function(game_type)
        if game_type:IsFinished() then
            local item  = UI.Manager:LoadItem(_C.UI.ITEM.GAMETYPE, GameTypeWindow.PARAMS.Content)
            item:Init(game_type)
    
            UISimpleEventListener.PGet(item.GO , item).onClick_P = function()
                Controller.Main.SelectGameType(game_type)
    
                GameTypeWindow.OnClose()
            end
        end
    end)
end

function GameTypeWindow.OnClose()
    UI.GameTypeWindow.ProgressHide(UI.GameTypeWindow,_C.UI.WINDOW.GAMETYPE)
end


function GameTypeWindow.OnDestroy()

end



return GameTypeWindow