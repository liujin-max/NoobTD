
local LoseWindow = {}
setmetatable(LoseWindow, {__index = WindowBase})

local P     = {}


function LoseWindow.Awake(items)
    -- LoseWindow.PARAMS.BtnContinue      = items["BtnContinue"]



    -- UI.Manager:RegisterBtnScale(LoseWindow.PARAMS.BtnContinue)

    -- UIEventListener.PGet(LoseWindow.PARAMS.BtnContinue,    LoseWindow).onClick_P = function()
    --     Logic.Battle.Resume()
    -- end

end




function LoseWindow.OnDestroy()
    P   = {}



end



return LoseWindow