--游戏主题

local GameTheme = Class.define("Data.GameTheme")

function GameTheme:SyncMSG(msg)
    self.FinishFlag = true

    if msg.Attention ~= nil then
        self.Attention  = msg.Attention
    end
    
    if msg.Level ~= nil then
        self.Level      = msg.Level
    end

    if msg.Exp ~= nil then
        self.Exp        = msg.Exp
    end
end

function GameTheme:ctor(config)
    self.ID             = config.ID
    self.Name           = config.Name
    self.Time           = config.Time   --开发时长
    self.Cost           = config.Cost   --费用
    
    --事件触发和条件触发互斥，只能填写其中一个
    self.Conditions     = ParseConditions(config.condition)
    self.Events         = ParseConditions(config.event)
    self.FinishFlag     = self.Conditions:Count() == 0 and self.Events:Count() == 0 --是否解锁

    self.Attention      = 100   --关注度

    self.Level          = 1     --等级
    self.Exp            = 0     --经验

end

function GameTheme:GetLevel()
    return self.Level
end

function GameTheme:GetUpgradeNeed()
    return Table.Get(Table.UpgradeLevelTable, self.Level).Exp
end

function GameTheme:IsLevelMax()
    return self:GetUpgradeNeed() == nil
end

function GameTheme:Upgrade()
    self.Exp    = 0
    self.Level  = self.Level + 1
end

function GameTheme:GetAttention()
    return self.Attention
end

function GameTheme:GetCost()
    return self.Cost / 2 * self.Level + self.Cost
end

function GameTheme:Finish()
    self.FinishFlag = true    
end

function GameTheme:IsFinished()
    return self.FinishFlag
end

function GameTheme:Check()
    if self.Events:Count() > 0 then
        return false
    end

    for i = 1, self.Conditions:Count() do
        local condition = self.Conditions:Get(i)
        if condition:Check() == false then
            return false
        end
    end
    return true
end

function GameTheme:Execute(params)
    if self.Conditions:Count() > 0 then
        return false
    end

    for i = 1, self.Events:Count() do
        local condition = self.Events:Get(i)
        if condition:Execute(params) == false then
            return false
        end
    end
    return true
end

return GameTheme