--训练项目

local TrainingFlag = Class.define("Data.TrainingFlag")

function TrainingFlag:GetCost()
    return self.Cost
end

function TrainingFlag:GetAttributes()
    return self.Attributes
end

function TrainingFlag:SyncMSG(msg)
    self.UnlockFlag     = true
        
    if msg.TrainCount ~= nil then
        self.TrainCount = msg.TrainCount
    end
end

function TrainingFlag:ctor(config)
    self.ID         = config.ID
    self.Name       = config.Name
    self.Type       = config.Type
    self.Level      = config.Level
    self.Cost       = config.Cost
    
    self.Attributes = {}
    self.Attributes[_C.ATTRIBUTE.SPEED]     = config.Speed
    self.Attributes[_C.ATTRIBUTE.PLAN]      = config.Plan
    self.Attributes[_C.ATTRIBUTE.PROGRAM]   = config.Program
    self.Attributes[_C.ATTRIBUTE.ARTS]      = config.Arts
    self.Attributes[_C.ATTRIBUTE.MUSIC]     = config.Music

    self.Conditions = ParseConditions(config.condition)

    self.TrainCount = 0     --训练次数
    self.UnlockFlag = false
end

function TrainingFlag:IsUnlock()
    return self.UnlockFlag
end

function TrainingFlag:AddCount(value)
    self.TrainCount = self.TrainCount + value
end

function TrainingFlag:Check(params)
    if self:IsUnlock() == true then return false end

    for i = 1, self.Conditions:Count() do
        local condition = self.Conditions:Get(i)
        if condition:Check(params) == false then
            return false
        end
    end
    return true
end

function TrainingFlag:Unlock()
    self.UnlockFlag = true
end

return TrainingFlag