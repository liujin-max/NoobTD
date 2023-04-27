
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


    return true
end

--单位死亡
function BattleLogic.Dead(unit)
    unit:Dead()
end





return BattleLogic