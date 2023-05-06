
--战斗逻辑处理

local BattleLogic    = {}

--@region 功能性接口
function BattleLogic.Distance(pos1, pos2)
    return Vector3.Distance(pos1, pos2)
end

--范围检测
function BattleLogic.RadiusCheck(pos1, pos2, radius)
    local dis = BattleLogic.Distance(pos1, pos2)
    return dis <= radius
end

function BattleLogic.Normalize(vector)
    return Vector3.Normalize(vector)
end

function BattleLogic.angle_360(from_, to_)
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
function BattleLogic.angle_radius_point(center, angle, radius)
    local radian    = angle * math.pi / 180
    local x_margin  = math.sin(radian) * radius
    local y_margin  = math.cos(radian) * radius

    local point     = Vector3.New(center.x + x_margin, center.y + y_margin, 0)
    return point
end


--@endregion


-----------------------------------
--@region 游戏逻辑
--单位是否有效
function BattleLogic.IsAvailable(unit)
    if unit == nil then
        return false
    end    

    if unit:IsDead() == true or unit.StateFlag._IsGC == true then
        return false
    end

    if unit.StateFlag._IsBorn == false then
        return false
    end

    return true
end

--单位死亡
function BattleLogic.Dead(unit)
    unit:Dead()
end

--塔的价格
function BattleLogic.GetTowerCost(id)
    local config    = Table.Get(Table.TowerTable, id)
    local cost      = config.Cost

    return cost
end

--
function BattleLogic.Pause()
    Battle.FIELD:Pause()

    UI.Manager:LoadUIWindow(_C.UI.WINDOW.PAUSE, UI.Manager.BORAD)
end

function BattleLogic.Resume()
    Battle.FIELD:Resume()

    UI.Manager:UnLoadWindow(_C.UI.WINDOW.PAUSE)
end

--@endregion





return BattleLogic