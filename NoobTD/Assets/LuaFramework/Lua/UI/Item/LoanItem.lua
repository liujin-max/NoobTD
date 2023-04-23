local LoanItem = {}

function LoanItem:Awake(items)
    self.Bottom     = items["Bottom"]
    self.Reward     = items["Reward"]
    self.Cost       = items["Cost"]
    self.Times      = items["Times"]
    self.CountDown  = items["CountDown"]

    self.BtnConfirm = items["BtnConfirm"]
    self.BtnRepay   = items["BtnRepay"]
    self.CanvasG    = self.Bottom:GetComponent("CanvasGroup")

    UISimpleEventListener.PGet(self.BtnConfirm, self).onClick_P = function()
        Controller.Bank.SelectLoan(self.Loan)
    end

    UISimpleEventListener.PGet(self.BtnRepay,   self).onClick_P = function()
        Controller.Bank.RepayLoan(self.Loan)
    end
end


function LoanItem:Init(loan)
    self.Loan       = loan

    self.Reward.text  = SetShowNumber(loan:GetReward()) .. "元"

    local cost      = loan:GetCost()
    self.Cost.text  = SetShowNumber(cost) .. "元"

    local timer     = loan:GetTime()
    local total     = timer:GetTotal()
    self.Times.text = total / (_C.CONST.WEEKSECOND * 4) .. "个月"

    self.BtnConfirm:SetActive(loan.IsSign == false)
    self.CountDown.gameObject:SetActive(loan.IsSign)
    self.BtnRepay:SetActive(loan.IsSign)
    if loan.IsSign == true then
        local seconds       = timer:GetCurrent()
        local left          = math.ceil((total - seconds) / (_C.CONST.WEEKSECOND * 4))
        self.CountDown.text = string.format("还款剩余时间：<#FF180F>%d</color>个月", left)
    end
end

function LoanItem:Show(flag)
    if flag == true then
        self.CanvasG.alpha = 1
    else
        self.CanvasG.alpha = 0.6
    end 
end

function LoanItem:OnDestroy()

end


return LoanItem