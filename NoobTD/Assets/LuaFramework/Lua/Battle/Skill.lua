--技能
--可升级
local Skill = Class.define("Battle.Skill")


function Skill:ctor(config, caster)
    self.Owner      = caster

    self.Table      = config
    self.ID         = config.ID
    self.Name       = config.Name
    self.Class      = config.Class
    self.Level      = config.Level
    self.DisplayID  = config.DisplayName

    self.Timer      = Class.new(Logic.CDTimer, 99999)   --冷却时间
    self.ATKINC     = Class.new(Data.AttributeValue, config.AtkInc)   --伤害倍率
    self.RANGE      = Class.new(Data.AttributeValue, config.Range)   --攻击范围

    --目标筛选类型
    local detect_dic= split(config.Harted, ":")
    self.DetectID   = tonumber(detect_dic[1])
    self.DetectCount= tonumber(detect_dic[2] or 1)
    
    self.PickID     = _C.SKILL.PICK.ENEMY

    self.Targets    = Class.new(Array)

    --表现类
    self.Show       = Class.new(Display.SkillShow, self)
end

function Skill:GetRange()
    return self.RANGE:ToNumber()
end

function Skill:IsReady()
    return self.Timer:IsFinished()
end

function Skill:IsCasting()
    return self.Show:IsCasting()
end

--重置CD
--CD在一个区间内随机
function Skill:ResetCD()
    local value     = Utility.Random.Range(self.Table.CD[1], self.Table.CD[2] or self.Table.CD[1])
    self.Timer:Reset(value)
end

function Skill:Check()
    
end

function Skill:Cast(targets)
    self.Targets    = targets
    self.Timer:Reset()

    self.Show:Cast()

    --朝向目标
    local t = targets:First()
    if t ~= nil then
        Logic.Battle.FaceTarget(self.Owner, t)
    end
end

--打断
function Skill:Interrupt()
    self.Show:Interrupt()
end

function Skill:Over()
    self.Show:Over()
end

function Skill:Update(deltatime)
    if self:IsCasting() == false then
        self.Timer:Update(deltatime)
    else
        self.Show:Update(deltatime)

        if self.Show:IsOver() == true then 
            self:Over()
        end
    end
end



return Skill