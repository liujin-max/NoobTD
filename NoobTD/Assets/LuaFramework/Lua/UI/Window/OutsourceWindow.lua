
local OutsourceWindow = {}
setmetatable(OutsourceWindow, {__index = WindowBase})

local P     = {}


local function NewAttributeItem(idx)
    local item  = P.AttributeItems:Get(idx)
    if item == nil then
        item    = UI.Manager:LoadItem(_C.UI.ITEM.ATTRIBUTE, OutsourceWindow.PARAMS.AttributePivot)

        P.AttributeItems:Add(item)
    end
    item.GO:SetActive(true)
    return item
end


function OutsourceWindow.Awake(items)
    OutsourceWindow.PARAMS.Name             = items["Name"]
    OutsourceWindow.PARAMS.Time             = items["Time"]
    OutsourceWindow.PARAMS.Reward           = items["Reward"]
    OutsourceWindow.PARAMS.Coin             = items["Coin"]
    OutsourceWindow.PARAMS.AttributePivot   = items["AttributePivot"]
    OutsourceWindow.PARAMS.PointContent     = items["PointContent"]

    OutsourceWindow.PARAMS.ArrowLeft        = items["ArrowLeft"]
    OutsourceWindow.PARAMS.ArrowRight       = items["ArrowRight"]
    OutsourceWindow.PARAMS.BtnConfirm       = items["BtnConfirm"]
    OutsourceWindow.PARAMS.BtnClose         = items["BtnClose"]
    OutsourceWindow.PARAMS.Mask             = items["Mask"]
    OutsourceWindow.PARAMS.BtnConfirm       = items["BtnConfirm"]


    P.AttributeItems    = Class.new(Array)
    P.Points            = Class.new(Array)

    UIEventListener.PGet(OutsourceWindow.PARAMS.Mask,          OutsourceWindow).onClick_P = function()
        Controller.Outsource.Dispose()
    end

    UIEventListener.PGet(OutsourceWindow.PARAMS.BtnClose,      OutsourceWindow).onClick_P = function()
        Controller.Outsource.Dispose()
    end

    UIEventListener.PGet(OutsourceWindow.PARAMS.BtnConfirm,      OutsourceWindow).onClick_P = function()
        Controller.Outsource.BuildOutsource()
    end

    UIEventListener.PGet(OutsourceWindow.PARAMS.ArrowLeft,      OutsourceWindow).onClick_P = function()
        Controller.Outsource.SwitchLeft()
    end

    UIEventListener.PGet(OutsourceWindow.PARAMS.ArrowRight,      OutsourceWindow).onClick_P = function()
        Controller.Outsource.SwitchRight()
    end
end

function OutsourceWindow.Init()
    OutsourceWindow.InitPoints()
    OutsourceWindow.FlushUI()
end

function OutsourceWindow.InitPoints()
    for i = 1, Controller.Outsource.Outsources():Count() do
       local item   = UI.Manager:LoadPointItem(OutsourceWindow.PARAMS.PointContent) 
       item:Show(false)
       P.Points:Add(item)
    end
end

function OutsourceWindow.InitAttributes(current)
    for i = _C.ATTRIBUTE.PLAN , _C.ATTRIBUTE.MUSIC  do
        local attribute     = current:GetAttribute(i)
        local value         = attribute:GetTotal()
        local item  = NewAttributeItem(i)
        item:Init(i, value)
        item:ShowBottom(true)
        item:TurnGray(value == 0)
        item:ShowCount(value > 0)
    end
end

function OutsourceWindow.FlushUI()
    local current   = Controller.Outsource.Current()
    local index     = Controller.Outsource.Index()

    OutsourceWindow.PARAMS.Name.text    = current.Name
    OutsourceWindow.PARAMS.Time.text    = current:GetTime() / _C.CONST.WEEKSECOND .. "周"
    OutsourceWindow.PARAMS.Reward.text  = current:GetReward()
    OutsourceWindow.PARAMS.Coin.text    = current:GetCoin()

    OutsourceWindow.InitAttributes(current)

    P.Points:Each(function(item, idx)
        item:Show(idx == index)
    end)
end



function OutsourceWindow.OnDestroy()
    P.Points:Each(function(item)
        UI.Manager:UnloadPointItem(item)
    end)

    P   = {}
end



return OutsourceWindow