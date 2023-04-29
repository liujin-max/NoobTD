
--伤害逻辑处理

local HitSettle    = {}

local ENUM          = {}

--攻击类型Hit 处理
ENUM[_C.HIT.TYPE.ATK]   = function(hit)
    local caster    = hit.Caster
    local target    = hit.Target

    local value     = Logic.HitSettle.GetDemage(hit)
    local armor     = target:GetARMOR()

    if armor > 0 then   --有护甲
        if value > armor then
            target:UpdateARMOR(-armor)

            local offset = value - armor
            target:UpdateHP(-offset)
        else
            target:UpdateARMOR(-value)
        end
    else
        target:UpdateHP(-value)
    end

    if target:GetHP() <= 0 then
        Logic.Battle.Dead(target)
    end

    print(target:GetHP())
end

--治疗类型Hit 处理
ENUM[_C.HIT.TYPE.HEAL]   = function(hit)
    local caster    = hit.Caster
    local target    = hit.Target

    local value     = Logic.HitSettle.GetDemage(hit)

    target:UpdateHP(value)
end

--护甲类型Hit 处理
ENUM[_C.HIT.TYPE.ARMOR]   = function(hit)
    local caster    = hit.Caster
    local target    = hit.Target

    local value     = Logic.HitSettle.GetDemage(hit)

    target:UpdateARMOR(value)
end


--创建hit
--hit_type  => 攻击|治疗|护甲
--atk_inc   => 自定义伤害倍率(不看Skill)
function HitSettle.New(hit_type, caster, target, skill, atk_inc)
    local hit   = Class.new(Battle.Hit, hit_type, caster, target, skill)

    if atk_inc ~= nil then
        hit:SetATKINC(atk_inc)
    end

    Battle.FIELD:RegisterHit(hit)
end

--结算hit
function HitSettle.Settle(hit)
    local entity = ENUM[hit.HitType]
    if entity == nil then
        assert(entity, "ENUM is nil : " .. tostring(hit.HitType))
        return
    end

    entity(hit)
end

--伤害
function HitSettle.GetDemage(hit)
    local base  = hit.Caster:GetATK() * hit.ATKINC:ToNumber() / 100.0

    if hit.CritFlag == true then    --暴击了
        base    = base * 1.5
    end

    return math.floor(base)
end

return HitSettle