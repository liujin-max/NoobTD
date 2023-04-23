--事件

local StoryEvent = Class.define("Data.StoryEvent")

function StoryEvent:IsFinished()
    return self.FinishFlag
end

function StoryEvent:ctor(config)
    self.ID         = config.ID
    self.Name       = config.Name

    self.IsRepeat   = config.IsRepeat == 1  --可重复

    self.Conditions = ParseConditions(config.condition)
    self.Effects    = ParseEventEffect(config.effect)


    self.FinishFlag = false
end

function StoryEvent:Check(params)
    if self:IsFinished() == true then return false end
    
    for i = 1, self.Conditions:Count() do
        local condition = self.Conditions:Get(i)
        if condition:Check(params) == false then
            return false
        end
    end
    return true
end

function StoryEvent:Execute()
    print("测试输出 执行事件：" .. self.Name)
    if self.IsRepeat == false then
        self.FinishFlag = true
    end

    self.Effects:Each(function(eff)
        eff:Execute()
    end)
end


return StoryEvent