
local SidelineWindow = {}
setmetatable(SidelineWindow, {__index = WindowBase})

local P     = {}


function SidelineWindow.Awake(items)
    SidelineWindow.PARAMS.Tip       = items["Tip"]


    P.Count = 0

    LuaEventManager.AddHandler(_E.SECOND_PASSED,    SidelineWindow.OnSecondPassed,  SidelineWindow, SidelineWindow)
end

function SidelineWindow.OnSecondPassed(pself, event)
    P.Count = P.Count + 1

    if P.Count > 3 then
        P.Count = 1
    end

    local str = ""
    for i = 1, P.Count do
        str = str .. "."
    end

    SidelineWindow.PARAMS.Tip.text  = "外出打工" .. str
end


function SidelineWindow.OnDestroy()
    P   = {}

    LuaEventManager.DelHandler(_E.SECOND_PASSED,    SidelineWindow.OnSecondPassed,  SidelineWindow, SidelineWindow)
end



return SidelineWindow