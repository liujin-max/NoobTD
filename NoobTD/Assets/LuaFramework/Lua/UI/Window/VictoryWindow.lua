
local VictoryWindow = {}
setmetatable(VictoryWindow, {__index = WindowBase})

local P     = {}


function VictoryWindow.Awake(items)
    -- VictoryWindow.PARAMS.BtnContinue      = items["BtnContinue"]



    -- UI.Manager:RegisterBtnScale(VictoryWindow.PARAMS.BtnContinue)

    -- UIEventListener.PGet(VictoryWindow.PARAMS.BtnContinue,    VictoryWindow).onClick_P = function()
    --     Logic.Battle.Resume()
    -- end

end




function VictoryWindow.OnDestroy()
    P   = {}



end



return VictoryWindow