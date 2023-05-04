
--负责筛选技能的目标

local TargetFilter    = {}

local TARGETS   = {}

--距离终点最近的n个人
TARGETS[_C.SKILL.DETECT.NORMAL] = function(skill, targets, count)
    local RET       = Class.new(Array)
    local temp      = {}

    targets:Each(function(t)
        local node = t:GetCurrentRoute()
        if node ~= nil then
            temp[#temp + 1] = {Distance = node.Distance, Target = t}
        end
    end)

    if #temp > 0 then
        table.sort(temp, function(a1, a2)
            return a1.Distance > a2.Distance
        end)

        for i = 1, count do
            local cfg = temp[i]
            if cfg == nil then
                break
            end

            RET:Add(cfg.Target)
        end
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


    local finals = entity(skill, targets, 1)

    if finals:Count() == 0 then
        return false
    end

    return true, finals
end

return TargetFilter