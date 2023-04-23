
local FactoryPauseWindow = {}
setmetatable(FactoryPauseWindow, {__index = WindowBase})

local P     = {}


function FactoryPauseWindow.Awake(items)
    FactoryPauseWindow.PARAMS.BtnContinue    = items["BtnContinue"]

    UIEventListener.PGet(FactoryPauseWindow.PARAMS.BtnContinue,  FactoryPauseWindow).onClick_P = function()
        UI.FactoryPauseWindow.ProgressHide(UI.FactoryPauseWindow,_C.UI.WINDOW.FACTORYPAUSE)
    end
end


function FactoryPauseWindow.OnDestroy()
    P   = {}

end



return FactoryPauseWindow