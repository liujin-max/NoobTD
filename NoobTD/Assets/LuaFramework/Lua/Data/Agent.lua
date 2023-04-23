--发行商

local Agent = Class.define("Data.Agent")


function Agent:SyncMSG(msg)
    if msg.Exp ~= nil then
        self.Exp    = msg.Exp
    end
end

function Agent:ctor(config)
    self.ID         = config.ID
    self.Name       = config.Name
    self.Coin       = config.Coin       --授权金
    self.Intimacy   = config.Intimacy   --亲密度
    self.Sales      = config.Sales      --销量加成

    --解锁条件
    self.Conditions = ParseConditions(config.condition)

    self.Exp        = 0
end

function Agent:GetSaleRate()
    local rate          = self.Sales
    local intimacy_rate = rate * (self.Exp / self.Intimacy)
    return 1 + (rate + intimacy_rate) / 100.0
end

function Agent:GetReward()
    return self.Coin
end

function Agent:IsUnlock()
    for i = 1, self.Conditions:Count() do
        local condition = self.Conditions:Get(i)
        if condition:Check() == false then
            return false, condition:Description()
        end
    end
    return true
end


return Agent