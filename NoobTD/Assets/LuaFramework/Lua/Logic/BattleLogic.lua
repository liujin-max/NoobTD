
--战斗逻辑处理

local BattleLogic    = {}

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