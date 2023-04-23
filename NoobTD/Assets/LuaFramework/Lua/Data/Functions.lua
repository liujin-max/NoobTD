--功能解锁


local Functions = Class.define("Data.Functions")

function Functions:IsFinished()
    return self.FinishFlag
end

function Functions:SyncMSG(msg)
    self.FinishFlag = true    
end

function Functions:ctor(config)
    self.ID         = config.ID
    self.Name       = config.Name

    self.Conditions = ParseConditions(config.condition) --满足其一就行
    self.Effects    = ParseEventEffect(config.effect)


    self.FinishFlag = false
end

function Functions:Check(params)
    if self.Conditions:Count() == 0 then
        return true
    end
    
    for i = 1, self.Conditions:Count() do
        local condition = self.Conditions:Get(i)
        if condition:Check(params) == true then
            return true
        end
    end
    return false
end

function Functions:Execute()
    print("测试输出 执行Functions：" .. self.Name)
    self.FinishFlag = true
    self.Effects:Each(function(eff)
        eff:Execute()
    end)
end

return Functions