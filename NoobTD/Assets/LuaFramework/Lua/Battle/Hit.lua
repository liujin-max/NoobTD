--打击
--结算逻辑
local Hit = Class.define("Battle.Hit")


function Hit:ctor(hit_type, caster, target, skill)
    self.HitType    = hit_type
    self.Caster     = caster
    self.Target     = target
    self.Skill      = skill

    --暴击
    self.CritFlag   = false
    --伤害倍率
    self.ATKINC     = Class.new(Data.AttributeValue, skill.ATKINC:ToNumber())

    self.HitEffects = ParseEffect(skill.Table.HitEffects)
end


function Hit:SetATKINC(value)
    self.ATKINC:SetBase(value)    
end

--触发
function Hit:Trigger()
    Logic.HitSettle.Settle(self)

    self.HitEffects:Each(function(e)
        e:Finish(self)
    end)
end

return Hit