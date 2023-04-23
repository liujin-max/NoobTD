
local ConsoleMainWindow = {}
setmetatable(ConsoleMainWindow, {__index = WindowBase})

local P     = {}


function ConsoleMainWindow.Awake(items)
    ConsoleMainWindow.PARAMS.Mask           = items["Mask"]
    ConsoleMainWindow.PARAMS.BtnClose       = items["BtnClose"]
    ConsoleMainWindow.PARAMS.BtnConfirm     = items["BtnConfirm"]

    ConsoleMainWindow.PARAMS.BtnCPU         = items["BtnCPU"]
    ConsoleMainWindow.PARAMS.BtnGPU         = items["BtnGPU"]
    ConsoleMainWindow.PARAMS.BtnRAM         = items["BtnRAM"]
    ConsoleMainWindow.PARAMS.CPU            = items["CPU"]
    ConsoleMainWindow.PARAMS.GPU            = items["GPU"]
    ConsoleMainWindow.PARAMS.RAM            = items["RAM"]

    ConsoleMainWindow.PARAMS.Cost           = items["Cost"]


   
    UIEventListener.PGet(ConsoleMainWindow.PARAMS.Mask,    ConsoleMainWindow).onClick_P = function()
        Controller.Console.Dispose()
    end

    UIEventListener.PGet(ConsoleMainWindow.PARAMS.BtnClose,    ConsoleMainWindow).onClick_P = function()
        Controller.Console.Dispose()
    end

    UIEventListener.PGet(ConsoleMainWindow.PARAMS.BtnConfirm,    ConsoleMainWindow).onClick_P = function()
        Controller.Console.BuildConsole()
    end

    UIEventListener.PGet(ConsoleMainWindow.PARAMS.BtnCPU,    ConsoleMainWindow).onClick_P = function()
        UI.Manager:LoadUIWindow(_C.UI.WINDOW.CONSOLEELEMENT, UI.Manager.MAJOR_ABOVE)
        UI.ConsoleElementWindow.Init(Controller.Data.Menu():GetCPUs())
    end

    UIEventListener.PGet(ConsoleMainWindow.PARAMS.BtnGPU,    ConsoleMainWindow).onClick_P = function()
        UI.Manager:LoadUIWindow(_C.UI.WINDOW.CONSOLEELEMENT, UI.Manager.MAJOR_ABOVE)
        UI.ConsoleElementWindow.Init(Controller.Data.Menu():GetGPUs())
    end

    UIEventListener.PGet(ConsoleMainWindow.PARAMS.BtnRAM,    ConsoleMainWindow).onClick_P = function()
        UI.Manager:LoadUIWindow(_C.UI.WINDOW.CONSOLEELEMENT, UI.Manager.MAJOR_ABOVE)
        UI.ConsoleElementWindow.Init(Controller.Data.Menu():GetRAMs())
    end

    LuaEventManager.AddHandler(_E.CONSOLE_WINDOW_FLUSH, ConsoleMainWindow.OnFlushUI,  ConsoleMainWindow,  ConsoleMainWindow)
end

function ConsoleMainWindow.Init()
    ConsoleMainWindow.FlushUI()
end

function ConsoleMainWindow.FlushUI()
    local cpu   = Controller.Console.CPU()
    local gpu   = Controller.Console.GPU()
    local ram   = Controller.Console.RAM()

    ConsoleMainWindow.PARAMS.CPU.text   = cpu and cpu.Name or ""
    ConsoleMainWindow.PARAMS.GPU.text   = gpu and gpu.Name or ""
    ConsoleMainWindow.PARAMS.RAM.text   = ram and ram.Name or ""

    local cost      = Controller.Data.Menu():GetConsoleCost(cpu, gpu,  ram)

    if Controller.Data.Account():GetMoney() < cost then
        ConsoleMainWindow.PARAMS.Cost.text = _C.COLOR.RED .. SetShowNumber(cost) .. "</color>"
    else
        ConsoleMainWindow.PARAMS.Cost.text = _C.COLOR.BLACK .. SetShowNumber(cost)  .. "</color>"
    end

end


function ConsoleMainWindow.OnFlushUI(pself, event)
    ConsoleMainWindow.FlushUI()
end


function ConsoleMainWindow.OnDestroy()
    LuaEventManager.DelHandler(_E.CONSOLE_WINDOW_FLUSH, ConsoleMainWindow.OnFlushUI,  ConsoleMainWindow)
end



return ConsoleMainWindow