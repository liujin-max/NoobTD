local ArtWindow = {}
setmetatable(ArtWindow, {__index = WindowBase})

local P     = {}

local function Active(obj,flag)
    if obj == nil then return end

    obj.transform:Find("Active").gameObject:SetActive(flag)
    obj.transform:Find("InActive").gameObject:SetActive(not flag)
end

local function SelectFlag(obj)
    Active(ArtWindow.PARAMS.D2,     false)
    Active(ArtWindow.PARAMS.D3,     false)

    Active(obj,    true)
end

function ArtWindow.Awake(items)
    ArtWindow.PARAMS.D2             = items["D2"]
    ArtWindow.PARAMS.D3             = items["D3"]

    ArtWindow.PARAMS.SSlider        = items["SSlider"]
    ArtWindow.PARAMS.ESlider        = items["ESlider"]

    ArtWindow.PARAMS.BtnConfirm     = items["BtnConfirm"]
  

    SelectFlag(nil)

    UIEventListener.PGet(ArtWindow.PARAMS.D2,     ArtWindow).onClick_P = function()
        SelectFlag(ArtWindow.PARAMS.D2)
        Controller.Art.UpdateVisual(1, 0)
    end

    UIEventListener.PGet(ArtWindow.PARAMS.D3,     ArtWindow).onClick_P = function()
        SelectFlag(ArtWindow.PARAMS.D3)
        Controller.Art.UpdateVisual(0, 1)
    end

    UIEventListener.PGet(ArtWindow.PARAMS.BtnConfirm,     ArtWindow).onClick_P = function()
        Controller.Art.Build()
    end

    UpdateManager.AddHandler(ArtWindow)
end

function ArtWindow.Init()
    
end

function ArtWindow.Update()
    local s_slider  = ArtWindow.PARAMS.SSlider:GetComponent("Slider")
    local e_slider  = ArtWindow.PARAMS.ESlider:GetComponent("Slider")


    Controller.Art.UpdateStyle(s_slider.value)
    Controller.Art.UpdateEffect(e_slider.value)
end


function ArtWindow.OnDestroy()
    UpdateManager.DelHandler(ArtWindow)
end



return ArtWindow