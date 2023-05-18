
--负责筛选技能的目标

local TargetFilter    = {}

local TARGETS   = {}

--距离终点最近的n个人
TARGETS[_C.SKILL.DETECT.NORMAL] = function(skill, targets, count)
    local RET   = Class.new(Array)

    for i = 1, count do
        local t = targets:Get(i)
        if t == nil then
            break
        end

        RET:Add(t)
    end

    return RET
end

--随机
TARGETS[_C.SKILL.DETECT.RAND] = function(skill, targets, count)
    local RET = Utility.Random.Pick(count , targets)

    return RET
end

--未被减速的人
TARGETS[_C.SKILL.DETECT.UNSLOW] = function(skill, targets, count)
    local RET   = Class.new(Array)

    local slows     = Class.new(Array)
    local normals   = Class.new(Array)

    for i = 1, targets:Count() do
        local t = targets:Get(i)
        if t:HasBuffByEntityID(1000) == true then
            slows:Add(t)
        else
            normals:Add(t)
        end
    end

    for i = 1, count do
        local t = normals:Get(i)
        if t == nil then
            break
        end
        RET:Add(t)
    end

    if RET:Count() < count then
        local surplus = count - RET:Count()
        for i = 1, surplus do
            local t = slows:Get(i)
            if t == nil then
                break
            end
            RET:Add(t)
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

    local o_pos     = skill.Owner:GetPos()
    local radius    = skill:GetRange() / 100.0
    local targets   = Class.new(Array)

    local temp      = Class.new(Array)
    local enemys    = Battle.FIELD.Positioner:GetUnits(skill.Owner.Side, skill.PickID)
    enemys:Each(function(e)
        if Logic.Battle.IsAvailable(e) == true then

            local dis = Utility.Battle.Distance(o_pos, e:GetPos())
            if Utility.Battle.RadiusCheck(o_pos, e:GetPos(), radius) == true then
                targets:Add(e)
            end

            local dis = Utility.Battle.Distance(o_pos, e:GetPos())
            if Utility.Battle.RadiusCheck(o_pos, e:GetPos(), radius) == true then
                local node = e:GetCurrentRoute()
                temp:Add({Distance = node ~= nil and node.Distance or 0, Target = e})

            end
        end        
    end)

    --按照终点仇恨排序（距离终点最近的人）
    temp:SortBy("Distance", true)
    temp:Each(function(cfg)
        targets:Add(cfg.Target)
    end)


    local finals = entity(skill, targets, skill.DetectCount)

    if finals:Count() == 0 then
        return false
    end

    return true, finals
end

return TargetFilter