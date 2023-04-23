--游戏类型

local GameType = Class.define("Data.GameType")

function GameType:GetFitters()
    return self.Fitters
end

function GameType:GetAddition(game_develop_type)
    return self.Additions[game_develop_type]
end


function GameType:SyncMSG(msg)
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

function GameType:ctor(config)
    self.ID             = config.ID
    self.Name           = config.Name
    self.Cost           = config.Cost           --费用
    self.Time           = config.Time           --开发时长

    --相性 => 极好->极差
    self.Fitters        = {}
    self.Fitters[_C.FETTER.EXCELLENT]   = config.Excellent
    self.Fitters[_C.FETTER.GOOD]        = config.Good
    self.Fitters[_C.FETTER.NORMAL]      = config.Normal
    self.Fitters[_C.FETTER.BAD]         = config.Bad
    self.Fitters[_C.FETTER.RANGE]       = config.Range
    self.Fitters[_C.FETTER.MIRACLE]     = config.Miracle

    self.Conditions     = ParseConditions(config.condition)
    self.FinishFlag     = self.Conditions:Count() == 0     --是否解锁

    self.Attention      = 100   --关注度

    self.Level          = 1     --等级
    self.Exp            = 0     --经验
end

function GameType:GetLevel()
    return self.Level
end

function GameType:GetUpgradeNeed()
    return Table.Get(Table.UpgradeLevelTable, self.Level).Exp
end

function GameType:IsLevelMax()
    return self:GetUpgradeNeed() == nil
end

function GameType:Upgrade()
    self.Exp    = 0
    self.Level  = self.Level + 1
end

function GameType:GetAttention()
    return self.Attention
end

function GameType:GetCost()
    return self.Cost / 2 * self.Level + self.Cost
end

function GameType:Finish()
    self.FinishFlag = true    
end

function GameType:IsFinished()
    return self.FinishFlag
end

function GameType:Check()
    for i = 1, self.Conditions:Count() do
        local condition = self.Conditions:Get(i)
        if condition:Check() == false then
            return false
        end
    end
    return true
end



return GameType