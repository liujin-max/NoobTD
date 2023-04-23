--贷款

local Loan = Class.define("Data.Loan")


function Loan:SyncMSG(msg)
    self.IsSign = true
    
    if msg.TimeCD ~= nil then
        self.TimeCD:Set(msg.TimeCD.Value, msg.TimeCD.Total)
    end
end

function Loan:ctor(cfg)
    self.ID         = cfg.ID
    self.Name       = cfg.Name
    self.Reward     = cfg.Reward
    self.Repay      = cfg.Repay

    self.TimeCD     = Class.new(Logic.CDTimer, cfg.Time)
    self.IsSign     = false     --贷款中
end

function Loan:ResetCD()
    self.TimeCD:Reset()
end

function Loan:GetReward()
    return self.Reward
end

function Loan:GetCost()
    return self.Repay
end

function Loan:GetTime()
    return self.TimeCD
end

function Loan:IsUnlock()
    return true
end

return Loan