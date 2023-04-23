--银行

local Bank = Class.define("Data.Bank")


function Bank:SyncMSG(msg)
    if msg.SignLoans ~= nil then
        self.SignLoans:Clear()
        for _, cfg in ipairs(msg.SignLoans) do
            local loan  = self:GetLoan(cfg.ID)
            assert(loan, "loan is nil  : " .. tostring(cfg.ID))

            loan:SyncMSG(cfg)
        end
    end
end

function Bank:ctor()
    self.Loans      = Class.new(Array)
    self.LoanDic    = {}

    Table.Each(Table.BankTable, function(cfg)
        local loan  = Class.new(Data.Loan, cfg)
        self.Loans:Add(loan)
        self.LoanDic[loan.ID] = loan        
    end)

    self.Loans:SortBy("ID", false)

    self.SignLoans  = Class.new(Array)
end

function Bank:GetLoans()
    return self.Loans
end

function Bank:GetLoan(id)
    return self.LoanDic[id]    
end

function Bank:GetSignLoans()
    return self.SignLoans
end

function Bank:SignLoan(loan)
    local reward    = loan:GetReward()
    Controller.System.Popup(string.format("获得贷款：%s元", SetShowNumber(reward)), nil, nil, true)

    Controller.Data.UpdateMoney(reward)
    Logic.MusicPlayer.PlaySound(SOUND.COIN)
    
    loan.IsSign = true
    loan:ResetCD()
    self.SignLoans:Add(loan)
end

function Bank:RepayLoan(loan)
    local cost  = loan:GetCost()
    Controller.System.Popup(string.format("偿还贷款：%s元", SetShowNumber(cost)), nil, nil, true)
    Controller.Data.UpdateMoney(-cost)

    Logic.MusicPlayer.PlaySound(SOUND.PAY)

    loan.IsSign = false
    loan:ResetCD()
    self.SignLoans:Remove(loan)
end


function Bank:Update(deltaTime)
    for i = self.SignLoans:Count() , 1, -1 do
        local loan = self.SignLoans:Get(i)

        loan.TimeCD:Update(deltaTime)
        if loan.TimeCD:IsFinished() == true then
            self:RepayLoan(loan)
        end
    end
end



return Bank