
--负责筛选技能的目标

local TargetFilter    = {}

local TARGETS   = {}

--距离终点最近的人
TARGETS[_C.SKILL.DETECT.NORMAL] = function(skill, targets)
    local RET       = Class.new(Array)
    local distance  = 0
    local target    = nil

    targets:Each(function(t)
        local node = t:GetCurrentRoute()
        if node ~= nil then
            if node.Distance > distance then
                distance    = node.Distance
                target      = t
            end
        end
    end)

    if target ~= nil then
        RET:Add(target)
    end

    return RET
end

function TargetFilter.Check(skill)
    local entity    = TARGETS[skill.DetectID]

    if entity == nil then 
        assert(entity , "TARGETS entity is nil : " .. tostring(skill.DetectID))
        return
    end

    local o_pos     = skill.Owner.Avatar:GetPosition()
    local radius    = skill:GetRadius() / 100.0
    local targets   = Class.new(Array)

    local enemys    = Battle.FIELD.Positioner:GetUnits(skill.Owner.Side, skill.PickID)
    enemys:Each(function(e)
        if Logic.Battle.IsAvailable(e) == true then
            local dis = Logic.Battle.Distance(o_pos, e.Avatar:GetPosition())
            if Logic.Battle.RadiusCheck(o_pos, e.Avatar:GetPosition(), radius) == true then
                targets:Add(e)
            end
        end        
    end)


    local finals = entity(skill, targets)

    if finals:Count() == 0 then
        return false
    end

    return true, finals
end

return TargetFilter