
local GameReadyWindow = {}
setmetatable(GameReadyWindow, {__index = WindowBase})

local P     = {}



function GameReadyWindow.Awake(items)
    GameReadyWindow.PARAMS.ConsoleName  = items["ConsoleName"]
    GameReadyWindow.PARAMS.NameIF       = items["Name"]:GetComponent("TMP_InputField")
    GameReadyWindow.PARAMS.Type         = items["Type"]
    GameReadyWindow.PARAMS.Theme        = items["Theme"]
    GameReadyWindow.PARAMS.AttributePivot = items["AttributePivot"]
    

    GameReadyWindow.PARAMS.BtnName      = items["BtnName"]
    GameReadyWindow.PARAMS.BtnSell      = items["BtnSell"]


    P.Attributes    = {}

    UIEventListener.PGet(GameReadyWindow.PARAMS.BtnSell,    GameReadyWindow).onClick_P = function()
        P.Game:SetName(GameReadyWindow.PARAMS.NameIF.text)
        if P.Callback ~= nil then
            P.Callback()
        end
    end

    LuaEventManager.AddHandler(_E.INPUTFIELD_ENDEDIT,       GameReadyWindow.OnNameEndEdit, GameReadyWindow, GameReadyWindow)
end

function GameReadyWindow.Init(game, call_back)
    P.Game      = game
    P.Callback  = call_back

    GameReadyWindow.InitAttributes(game)
    GameReadyWindow.FlushUI(game)
end

function GameReadyWindow.InitAttributes(game)
    for i = _C.ATTRIBUTE.PLAN , _C.ATTRIBUTE.MUSIC  do
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.ATTRIBUTE, GameReadyWindow.PARAMS.AttributePivot)
        item:Init(i, game:GetAttribute(i))

        P.Attributes[i] = item
    end
end

function GameReadyWindow.FlushUI(game)
    GameReadyWindow.PARAMS.ConsoleName.text = game.GameConsole.Name
    GameReadyWindow.PARAMS.NameIF.text      = game.Name
    GameReadyWindow.PARAMS.Type.text        = game.Type.Name
    GameReadyWindow.PARAMS.Theme.text       = game.Theme.Name

    for k, item in pairs(P.Attributes) do
        local score     = game:GetAttribute(k)
        item:SetScore(score)
        item:ShowScoreTag(Controller.Data.Account():GetScore(k) < score)
    end
end



function GameReadyWindow.OnNameEndEdit(pself, eventType, entity)
    if entity ~= GameReadyWindow.PARAMS.NameIF then return end

    if GameReadyWindow.PARAMS.NameIF.text == "" then
        GameReadyWindow.PARAMS.NameIF.text = P.Game.Name
    end
end

function GameReadyWindow.OnDestroy()
    P   = {}

    LuaEventManager.DelHandler(_E.INPUTFIELD_ENDEDIT,       GameReadyWindow.OnNameEndEdit, GameReadyWindow)
end



return GameReadyWindow