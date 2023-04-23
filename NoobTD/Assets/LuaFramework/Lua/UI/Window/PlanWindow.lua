local PlanWindow = {}
setmetatable(PlanWindow, {__index = WindowBase})

local P     = {}

local function Active(obj,flag)
    if obj == nil then return end

    obj.transform:Find("Active").gameObject:SetActive(flag)
    obj.transform:Find("InActive").gameObject:SetActive(not flag)
end

local function SelectFlag(obj)
    Active(PlanWindow.PARAMS.PayMent,   false)
    Active(PlanWindow.PARAMS.BuyOut,    false)

    Active(obj,    true)
end

function PlanWindow.Awake(items)
    PlanWindow.PARAMS.PayMent       = items["PayMent"]
    PlanWindow.PARAMS.BuyOut        = items["BuyOut"]

    PlanWindow.PARAMS.PSlider       = items["PSlider"]
    PlanWindow.PARAMS.DSlider       = items["DSlider"]

    PlanWindow.PARAMS.BtnConfirm    = items["BtnConfirm"]
  

    SelectFlag(nil)

    UIEventListener.PGet(PlanWindow.PARAMS.PayMent,     PlanWindow).onClick_P = function()
        SelectFlag(PlanWindow.PARAMS.PayMent)
        Controller.Plan.UpdatePurchase(1, 0)
    end

    UIEventListener.PGet(PlanWindow.PARAMS.BuyOut,     PlanWindow).onClick_P = function()
        SelectFlag(PlanWindow.PARAMS.BuyOut)
        Controller.Plan.UpdatePurchase(0, 1)
    end

    UIEventListener.PGet(PlanWindow.PARAMS.BtnConfirm,     PlanWindow).onClick_P = function()
        Controller.Plan.Build()
    end

    UpdateManager.AddHandler(PlanWindow)
end

function PlanWindow.Init()
    
end

function PlanWindow.Update()
    local p_slider  = PlanWindow.PARAMS.PSlider:GetComponent("Slider")
    local d_slider  = PlanWindow.PARAMS.DSlider:GetComponent("Slider")


    Controller.Plan.UpdatePlay(p_slider.value)
    Controller.Plan.UpdateDifficult(d_slider.value)
end


function PlanWindow.OnDestroy()
    UpdateManager.DelHandler(PlanWindow)
end



return PlanWindow