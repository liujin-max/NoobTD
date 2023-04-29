--技能
local Skill = Class.define("Battle.Skill")


function Skill:ctor(config, caster)
    self.Owner      = caster

    self.Table      = config
    self.ID         = config.ID
    self.Name       = config.Name


    self.Timer      = Class.new(Logic.CDTimer, config.CD / 1000.0)   --冷却时间
    self.ATKINC     = Class.new(Data.AttributeValue, config.AtkInc)   --伤害倍率
    self.RANGE      = Class.new(Data.AttributeValue, config.Range)   --攻击范围

    --目标筛选类型
    self.DetectID   = _C.SKILL.DETECT.NORMAL
    self.PickID     = _C.SKILL.PICK.ENEMY

    --释放中
    self.CastFlag   = false
    self.Targets    = Class.new(Array)
end

function Skill:GetRadius()
    return self.RANGE:ToNumber()
end

function Skill:IsReady()
    return self.Timer:IsFinished()
end

function Skill:IsCasting()
    return self.CastFlag
end

function Skill:Check()
    
end

function Skill:Cast(targets)
    self.CastFlag   = true
    self.Targets    = targets

    self.Timer:Reset()

    --
    self:Over()
end

function Skill:Over()
    self.CastFlag = false

end

function Skill:Update(deltatime)
    if self:IsCasting() == false then
        self.Timer:Update(deltatime)
    end
end



return Skill