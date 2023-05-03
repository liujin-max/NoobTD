
local PauseWindow = {}
setmetatable(PauseWindow, {__index = WindowBase})

local P     = {}


function PauseWindow.Awake(items)
    PauseWindow.PARAMS.BtnContinue      = items["BtnContinue"]



    UI.Manager:RegisterBtnScale(PauseWindow.PARAMS.BtnContinue)

    UIEventListener.PGet(PauseWindow.PARAMS.BtnContinue,    PauseWindow).onClick_P = function()
        Logic.Battle.Resume()
    end

end




function PauseWindow.OnDestroy()
    P   = {}



end



return PauseWindow