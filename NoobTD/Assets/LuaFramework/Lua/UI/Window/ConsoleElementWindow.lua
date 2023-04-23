
local ConsoleElementWindow = {}
setmetatable(ConsoleElementWindow, {__index = WindowBase})

local P     = {}


function ConsoleElementWindow.Awake(items)
    ConsoleElementWindow.PARAMS.Mask          = items["Mask"]
    ConsoleElementWindow.PARAMS.Content       = items["Content"]

    UIEventListener.PGet(ConsoleElementWindow.PARAMS.Mask,    ConsoleElementWindow).onClick_P = function()
        UI.ConsoleElementWindow.ProgressHide(UI.ConsoleElementWindow,_C.UI.WINDOW.CONSOLEELEMENT)
    end
    
end

function ConsoleElementWindow.Init(elements)
    ConsoleElementWindow.InitElements(elements)
end

function ConsoleElementWindow.InitElements(elements)
    elements:Each(function(element)
        if element:IsUnlock() then
            local item  = UI.Manager:LoadItem(_C.UI.ITEM.CONSOLEELEMENT, ConsoleElementWindow.PARAMS.Content.transform)
            item:Init(element)
    
            UISimpleEventListener.PGet(item.GO, item).onClick_P = function()
                element:Select()
    
                UI.ConsoleElementWindow.ProgressHide(UI.ConsoleElementWindow,_C.UI.WINDOW.CONSOLEELEMENT)
            end
        end
    end)
end




function ConsoleElementWindow.OnDestroy()

end



return ConsoleElementWindow