
--战斗逻辑处理

local BattleLogic    = {}


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

--
function BattleLogic.Pause()
    Battle.FIELD:Pause()

    UI.Manager:LoadUIWindow(_C.UI.WINDOW.PAUSE, UI.Manager.BORAD)
end

function BattleLogic.Resume()
    Battle.FIELD:Resume()

    UI.Manager:UnLoadWindow(_C.UI.WINDOW.PAUSE)
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

--朝向目标
function BattleLogic.FaceTarget(caster, target)
    local o_pos = caster.Avatar:GetPosition()
    local t_pos = target.Avatar:GetPosition()

    if t_pos.x > o_pos.x then
        caster:FaceTo(_C.AVATAR.FACE.RIGHT)
    else
        caster:FaceTo(_C.AVATAR.FACE.LEFT)
    end
end






return BattleLogic