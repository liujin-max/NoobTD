
local AgentWindow = {}
setmetatable(AgentWindow, {__index = WindowBase})

local P     = {}


function AgentWindow.Awake(items)
    AgentWindow.PARAMS.BtnConfirm       = items["BtnConfirm"]
    AgentWindow.PARAMS.ArrowLeft        = items["ArrowLeft"]
    AgentWindow.PARAMS.ArrowRight       = items["ArrowRight"]
    AgentWindow.PARAMS.BtnClose         = items["BtnClose"]

    AgentWindow.PARAMS.Name             = items["Name"]
    AgentWindow.PARAMS.Intimacy         = items["Intimacy"]
    AgentWindow.PARAMS.Bar              = items["Bar"]
    AgentWindow.PARAMS.Coin             = items["Coin"]
    AgentWindow.PARAMS.PointContent     = items["PointContent"]
    AgentWindow.PARAMS.LockTip          = items["LockTip"]


    P.Points        = Class.new(Array)

    UIEventListener.PGet(AgentWindow.PARAMS.ArrowLeft,  AgentWindow).onClick_P = function()
        UI.AgentWindow.SwitchLeft()
    end

    UIEventListener.PGet(AgentWindow.PARAMS.ArrowRight, AgentWindow).onClick_P = function()
        UI.AgentWindow.SwitchRight()
    end

    UIEventListener.PGet(AgentWindow.PARAMS.BtnConfirm, AgentWindow).onClick_P = function()
        Controller.Data.Agentor():SelectAgent(P.Current.ID)
    end

    UIEventListener.PGet(AgentWindow.PARAMS.BtnClose,   AgentWindow).onClick_P = function()
        UI.AgentWindow.ProgressHide(UI.AgentWindow,_C.UI.WINDOW.AGENT)
    end
end

function AgentWindow.Init(agents, info_mode)
    P.Agents        = agents
    P.InfoMode      = info_mode
    for i = 1, agents:Count() do
        local agent = agents:Get(i)
        if agent:IsUnlock() == true then
            P.Index     = i
            P.Current   = agent
        end
    end

    AgentWindow.InitPoints()
    AgentWindow.FlushUI()
end

function AgentWindow.InitPoints()
    P.Points:Each(function(item)
        UI.Manager:UnloadPointItem(item)        
    end)
    P.Points:Clear()

    for i = 1, P.Agents:Count() do
       local item   = UI.Manager:LoadPointItem(AgentWindow.PARAMS.PointContent) 
       item:Show(false)
       P.Points:Add(item)
    end
end

function AgentWindow.FlushUI()
    AgentWindow.PARAMS.Name.text    = P.Current.Name
    AgentWindow.PARAMS.Coin.text    = string.format(_C.MESSAGE.FORMATEPRICE, SetShowNumber(P.Current.Coin))

    local exp   = P.Current.Exp 
    local max   = P.Current.Intimacy
    AgentWindow.PARAMS.Intimacy.text    = string.format("%.1f%%", exp / max * 100.0)
    AgentWindow.PARAMS.Bar.fillAmount   = exp / max

    P.Points:Each(function(item, idx)
        item:Show(idx == P.Index)
    end)

    local is_unlock , description   = P.Current:IsUnlock()
    if is_unlock == true then
        AgentWindow.PARAMS.BtnConfirm:SetActive(true)
        AgentWindow.PARAMS.LockTip.gameObject:SetActive(false)
    else
        AgentWindow.PARAMS.BtnConfirm:SetActive(false)
        AgentWindow.PARAMS.LockTip.gameObject:SetActive(true)
        AgentWindow.PARAMS.LockTip.text =  _C.COLOR.GRAY .. description .. "</color>"
    end

    if P.InfoMode == true then
        AgentWindow.PARAMS.BtnConfirm:SetActive(false)
        AgentWindow.PARAMS.LockTip.gameObject:SetActive(true)

        if is_unlock == true then
            AgentWindow.PARAMS.LockTip.text =  _C.COLOR.GREEN2 .. "可以进行合作" .. "</color>"
        end
    end

    AgentWindow.PARAMS.BtnClose:SetActive(P.InfoMode == true)
end

function AgentWindow.SwitchLeft()
    if P.Index > 1 then
        P.Index = P.Index - 1
    else
        P.Index = P.Agents:Count()
    end

    P.Current   = P.Agents:Get(P.Index)

    AgentWindow.FlushUI()
end

function AgentWindow.SwitchRight()
    if P.Index == P.Agents:Count() then
        P.Index = 1
    else
        P.Index = P.Index + 1
    end

    P.Current   = P.Agents:Get(P.Index)

    AgentWindow.FlushUI()
end


function AgentWindow.OnDestroy()
    P   = {}
end



return AgentWindow