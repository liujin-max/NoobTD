
local AchievementTask = Class.define("Data.AchievementTask")


function AchievementTask:IsFinished()
    return self.FinishFlag
end

function AchievementTask:GetTriggerType()
    return self.TriggerType
end

function AchievementTask:SyncMSG(msg)
    self.FinishFlag     = true
        
end

function AchievementTask:ctor(config)
    self.ID             = config.ID
    self.Name           = config.Name
    self.Description    = config.Description

    self.TriggerType    = config.TriggerType
    self.IsEgg          = config.IsEgg == 1 

    self.Conditions     = ParseConditions(config.condition)
    self.Rewards        = ParseEventEffect(config.Reward)

    self.FinishFlag = false
end

function AchievementTask:Check(params)
    if self:IsFinished() == true then return false end

    for i = 1, self.Conditions:Count() do
        local condition = self.Conditions:Get(i)
        if condition:Check(params) == false then
            return false
        end
    end
    return true
end

function AchievementTask:Execute()
    self.FinishFlag = true

    self.Rewards:Each(function(eff)
        eff:Execute()
    end)

    Controller.System.ShowAchievement(self)
end

return AchievementTask