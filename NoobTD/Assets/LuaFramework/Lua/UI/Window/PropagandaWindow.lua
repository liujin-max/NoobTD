
local PropagandaWindow = {}
setmetatable(PropagandaWindow, {__index = WindowBase})


function PropagandaWindow.Awake(items)
    PropagandaWindow.PARAMS.Mask        = items["Mask"]
    PropagandaWindow.PARAMS.BtnConfirm  = items["BtnConfirm"]

    PropagandaWindow.PARAMS.Slider      = items["Slider"]
    PropagandaWindow.PARAMS.Cost        = items["Cost"]



    UIEventListener.PGet(PropagandaWindow.PARAMS.Mask,  PropagandaWindow).onClick_P = function()
        Controller.Propaganda.Dispose()
    end

    UIEventListener.PGet(PropagandaWindow.PARAMS.BtnConfirm,  PropagandaWindow).onClick_P = function()
        local s_slider  = PropagandaWindow.PARAMS.Slider:GetComponent("Slider")

        local value     = Controller.Propaganda.GetBudgetCost(s_slider.value)
        Controller.Data.Propaganda():UpdateBudget(value)

        Controller.Propaganda.Dispose()
    end

    UpdateManager.AddHandler(PropagandaWindow)
end

function PropagandaWindow.Init()
    PropagandaWindow.PARAMS.Slider:GetComponent("Slider").value = Controller.Propaganda.GetBudgetRate()

    PropagandaWindow.FlushUI()
end

function PropagandaWindow.FlushUI()
    local slider    = PropagandaWindow.PARAMS.Slider:GetComponent("Slider")
    local money     = Controller.Propaganda.GetBudgetCost(slider.value)

    PropagandaWindow.PARAMS.Cost.text   = "花费:" .. SetShowNumber(money) .. "元"
end

function PropagandaWindow.Update()
    PropagandaWindow.FlushUI()
end



function PropagandaWindow.OnDestroy()
    UpdateManager.DelHandler(PropagandaWindow)
end

return PropagandaWindow