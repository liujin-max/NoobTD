--战场工具类

local BattleUtility = {}

function BattleUtility.Distance(pos1, pos2)
    return Vector3.Distance(pos1, pos2)
end

--范围检测
function BattleUtility.RadiusCheck(pos1, pos2, radius)
    local dis = Utility.Battle.Distance(pos1, pos2)
    return dis <= radius
end


function BattleUtility.Normalize(vector)
    return Vector3.Normalize(vector)
end

--子弹朝向某个目标
function BattleUtility.TurnTo(effect, direction)
    local entity    = effect.Entity
    
    entity.transform.right = direction

    -- --2D
    -- local pre_scale = entity.transform.localScale
    -- if direction.x < 0 then
    --     entity.transform.right      = Vector3.New(-direction.x, -direction.y, direction.z)
    --     entity.transform.localScale = Vector3.New(-math.abs(pre_scale.x), pre_scale.y, pre_scale.z)
    -- else
    --     entity.transform.right      = direction
    --     entity.transform.localScale = Vector3.New(math.abs(pre_scale.x), pre_scale.y, pre_scale.z)
    -- end
end

function BattleUtility.Rotate(rotate, effect, o_pos, t_pos)
    if rotate == _C.ROTATE.BULLET.ZERO then
        effect:SetEulerAngles(Vector3.zero)
    elseif rotate == _C.ROTATE.BULLET.TURNTO then
        Utility.Battle.TurnTo(effect,  t_pos - o_pos)
    else
        effect:SetEulerAngles(Vector3.zero)
    end    
end

--获取抛物线的中心点坐标
function BattleUtility.parabola_middle_point(o_pos, t_pos, middle_height)
    local rate      = middle_height or 0.5
    local distance  = Utility.Battle.Distance(o_pos, t_pos)
    local height    = distance * rate

    if t_pos.y > o_pos.y then
        return Vector3.New((o_pos.x + t_pos.x) / 2,  t_pos.y + height, 0)
    end

    return Vector3.New((o_pos.x + t_pos.x) / 2,  o_pos.y + height, 0)
end

--二阶贝塞尔曲线
function BattleUtility.quardatic_bezier(t, start_pos, to_pos, middle_pos)
    local aa    = start_pos + (middle_pos - start_pos) * t
    local bb    = middle_pos + (to_pos - middle_pos) * t
    return aa + (bb - aa) * t
end

--三阶贝塞尔
function BattleUtility.cubic_bezier(t, start_pos, middle_pos1, middle_pos2, to_pos)
    local aa    = start_pos + (middle_pos1 - start_pos) * t
    local bb    = middle_pos1 + (middle_pos2 - middle_pos1) * t
    local cc    = middle_pos2 + (to_pos - middle_pos2) * t

    local aaa   = aa + (bb - aa) * t
    local bbb   = bb + (cc - bb) * t

    return aaa + (bbb - aaa) * t
end

function BattleUtility.angle_360(from_, to_)
    --两点的x、y值
    local x = from_.x - to_.x
    local y = from_.y - to_.y

    --斜边长度
    local hypotenuse = math.sqrt(math.pow(x,2) + math.pow(y,2))

    --求出弧度
    local cos = x / hypotenuse
    local radian = Mathf.Acos(cos);

    --用弧度算出角度    
    local angle = 180 / (math.pi / radian);
  
    if y < 0 then
        angle = -angle
    
    elseif (y == 0) and (x < 0) then
        angle = 180

    end

    return angle
end

--center：中心点 
--angle：角度 
--radius：半径
--以center为中心，angle角度、radius半径外的点
function BattleUtility.angle_radius_point(center, angle, radius)
    local radian    = angle * math.pi / 180
    local x_margin  = math.sin(radian) * radius
    local y_margin  = math.cos(radian) * radius

    local point     = Vector3.New(center.x + x_margin, center.y + y_margin, 0)
    return point
end



return BattleUtility