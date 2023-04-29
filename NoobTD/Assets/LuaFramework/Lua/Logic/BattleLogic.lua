
--战斗逻辑处理

local BattleLogic    = {}

--单位是否有效
function BattleLogic.IsAvailable(unit)
    if unit == nil then
        return false
    end    

    if unit:IsDead() then
        return false
    end

    if unit.StateFlag._IsGC == true then
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

--建造塔
function BattleLogic.BuildTower(id, defender)
    local tower   = Class.new(Battle.Tower, Table.Get(Table.TowerTable, id), _C.SIDE.DEFEND)
    tower:SetDefender(defender)
    defender:SetTower(tower)
    
    tower:InitBehaviour()

    Battle.FIELD.Positioner:PushTower(tower)
end




return BattleLogic