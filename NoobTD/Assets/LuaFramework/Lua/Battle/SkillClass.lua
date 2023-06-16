--系列技能
local SkillClass = Class.define("Battle.SkillClass")


function SkillClass:ctor(config, caster)
    self.Owner      = caster

    self.Table      = config
    self.ID         = config.ID
    self.Name       = config.Name
    self.Level      = config.Level

    self.Skills     = Class.new(Array)
    self.SkillDic   = {}

    for i, id in ipairs(config.Skills) do
        local skill = Class.new(Battle.Skill, Table.Get(Table.SkillTable, id), caster)
        self.Skills:Add(skill)
        self.SkillDic[id] = skill
    end
end

function SkillClass:GetSkill()
    return self.Skills:Get(self.Level)
end

function SkillClass:IsReady()
    local sk    = self:GetSkill()
    if sk ~= nil then
        return sk:IsReady()
    end

    return false
end

function SkillClass:IsCasting()
    local sk    = self:GetSkill()
    if sk ~= nil then
        return sk:IsCasting()
    end

    return false
end

function SkillClass:ResetCD()
    local sk    = self:GetSkill()
    if sk ~= nil then
        sk:ResetCD()
    end
end

function SkillClass:Update(deltatime)
    local sk    = self:GetSkill()
    if sk ~= nil then
        sk:Update(deltatime)
    end
end



return SkillClass