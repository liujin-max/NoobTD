
local BankWindow = {}
setmetatable(BankWindow, {__index = WindowBase})

local P     = {}

local function PLItem()
    if P.PLItem == nil then
        P.PLItem    = UI.Manager:LoadItem(_C.UI.ITEM.LOAN, BankWindow.PARAMS.PL.transform)
    end
    return P.PLItem
end

local function PRItem()
    if P.PRItem == nil then
        P.PRItem    = UI.Manager:LoadItem(_C.UI.ITEM.LOAN, BankWindow.PARAMS.PR.transform)
    end
    return P.PRItem
end

local function PCItem()
    if P.PCItem == nil then
        P.PCItem    = UI.Manager:LoadItem(_C.UI.ITEM.LOAN, BankWindow.PARAMS.PC.transform)
    end
    return P.PCItem
end

function BankWindow.Awake(items)
    BankWindow.PARAMS.Mask          = items["Mask"]
    BankWindow.PARAMS.PointContent  = items["PointContent"]
    BankWindow.PARAMS.ArrowLeft     = items["ArrowLeft"]
    BankWindow.PARAMS.ArrowRight    = items["ArrowRight"]

    BankWindow.PARAMS.PL    = items["PL"]
    BankWindow.PARAMS.PR    = items["PR"]
    BankWindow.PARAMS.PC    = items["PC"]

    P.Points        = Class.new(Array)

    UIEventListener.PGet(BankWindow.PARAMS.Mask,        BankWindow).onClick_P = function()
        Controller.Bank.Dispose()
    end

    UIEventListener.PGet(BankWindow.PARAMS.ArrowLeft,   BankWindow).onClick_P = function()
        BankWindow.SwitchLeft()
    end

    UIEventListener.PGet(BankWindow.PARAMS.ArrowRight,   BankWindow).onClick_P = function()
        BankWindow.SwitchRight()
    end
end

function BankWindow.Init()
    P.Loans     = Controller.Data.Bank():GetLoans()
    P.Index     = 1

    BankWindow.InitPoints()
    BankWindow.FlushUI()
end

function BankWindow.FlushUI()
    BankWindow.UpdateLoans()

    P.Points:Each(function(item, idx)
        item:Show(idx == P.Index)
    end)


    BankWindow.PARAMS.ArrowLeft:SetActive(P.Index > 1)
    BankWindow.PARAMS.ArrowRight:SetActive(P.Index < P.Loans:Count())
end

function BankWindow.InitPoints()
    P.Points:Each(function(item)
        UI.Manager:UnloadPointItem(item)        
    end)
    P.Points:Clear()

    for i = 1, P.Loans:Count() do
       local item   = UI.Manager:LoadPointItem(BankWindow.PARAMS.PointContent) 
       item:Show(false)
       P.Points:Add(item)
    end
end

function BankWindow.UpdateLoans()
    local loans  = P.Loans

    local c_loan = loans:Get(P.Index)
    local l_loan = loans:Get(P.Index - 1)
    local r_loan = loans:Get(P.Index + 1)

    local c_item = PCItem()
    local l_item = PLItem()
    local r_item = PRItem()
    
    if c_loan ~= nil then
        c_item.GO:SetActive(true)
        c_item:Init(c_loan)
        c_item:Show(true)
    else
        c_item.GO:SetActive(false)
    end

    if l_loan ~= nil then
        l_item.GO:SetActive(true)
        l_item:Init(l_loan)
        l_item:Show(false)
    else
        l_item.GO:SetActive(false)
    end

    if r_loan ~= nil then
        r_item.GO:SetActive(true)
        r_item:Init(r_loan)
        r_item:Show(false)
    else
        r_item.GO:SetActive(false)
    end
end

function BankWindow.SwitchLeft()
    if P.Index > 1 then
        P.Index = P.Index - 1
    end

    BankWindow.FlushUI()
end

function BankWindow.SwitchRight()
    if P.Index < P.Loans:Count() then
        P.Index = P.Index + 1
    end

    BankWindow.FlushUI()
end



function BankWindow.OnDestroy()
    P   = {}
end



return BankWindow