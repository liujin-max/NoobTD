
local GameThemeWindow = {}
setmetatable(GameThemeWindow, {__index = WindowBase})

local P     = {}


function GameThemeWindow.Awake(items)
    GameThemeWindow.PARAMS.Mask          = items["Mask"]
    GameThemeWindow.PARAMS.Content       = items["Content"]
    GameThemeWindow.PARAMS.BtnClose      = items["BtnClose"]

    UIEventListener.PGet(GameThemeWindow.PARAMS.Mask,       GameThemeWindow).onClick_P = GameThemeWindow.OnClose
    UIEventListener.PGet(GameThemeWindow.PARAMS.BtnClose,   GameThemeWindow).onClick_P = GameThemeWindow.OnClose
    
end

function GameThemeWindow.Init()
    GameThemeWindow.InitGameThemes()
end

function GameThemeWindow.InitGameThemes()
    local themes  = Controller.Data.Menu():GetGameThemes()

    themes:Each(function(game_theme)
        if game_theme:IsFinished() then
            local item  = UI.Manager:LoadItem(_C.UI.ITEM.GAMETHEME, GameThemeWindow.PARAMS.Content)
            item:Init(game_theme)
    
            UISimpleEventListener.PGet(item.GO, item).onClick_P = function()
                Controller.Main.SelectGameTheme(game_theme)
    
                GameThemeWindow.OnClose()
            end
        end
    end)
end

function GameThemeWindow.OnClose()
    UI.GameThemeWindow.ProgressHide(UI.GameThemeWindow,_C.UI.WINDOW.GAMETHEME)
end



function GameThemeWindow.OnDestroy()

end



return GameThemeWindow