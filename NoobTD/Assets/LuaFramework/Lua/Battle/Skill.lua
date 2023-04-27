--技能
local Skill = Class.define("Battle.Skill")


function Skill:ctor(config, caster)
    self.Table      = config
    self.ID         = config.ID
    self.Name       = config.Name


    self.Timer      = Class.new(Logic.CDTimer, config.CD)   --冷却时间
    self.ATKINC     = Class.new(Data.AttributeValue, 100)   --伤害倍率
    self.RANGE      = Class.new(Data.AttributeValue, 100)   --攻击范围
end

function Skill:IsReady()
    return self.Timer:IsFinished()
end

function Skill:Update(deltatime)
    self.Timer:Update(deltatime)
end


return Skill