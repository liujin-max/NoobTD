local MonumentWindow = {}
setmetatable(MonumentWindow, {__index = WindowBase})

local P     = {}


function MonumentWindow.Awake(items)
    MonumentWindow.PARAMS.Content           = items["Content"]

    MonumentWindow.PARAMS.Mask              = items["Mask"]

    UISimpleEventListener.PGet(MonumentWindow.PARAMS.Mask,  MonumentWindow).onClick_P = function()
        UI.MonumentWindow.ProgressHide(UI.MonumentWindow,_C.UI.WINDOW.MONUMENT)
    end
end

function MonumentWindow.Init()
    MonumentWindow.InitCompanys()
end

function MonumentWindow.InitCompanys()
    local companys  = Controller.Data.Monument():GetCompanys()
    companys:Each(function(company)
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.MONUMENT, MonumentWindow.PARAMS.Content)
        item:Init(company)
    end)
end


function MonumentWindow.OnDestroy()

end



return MonumentWindow