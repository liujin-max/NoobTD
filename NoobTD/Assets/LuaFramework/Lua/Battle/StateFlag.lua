--状态
local StateFlag = Class.define("Battle.StateFlag")


function StateFlag:ctor(owner)
    self.Owner  = owner

    
    self._IsBorn    = false     --诞生
    self._IsReach   = false     --到达终点

    --从开始死亡到真正从内存中清除 有一个过程
    --播放死亡动画、执行死亡附带的逻辑等等
    self._IsDead    = false     --死亡
    self._IsGC      = false     --需要从内存中清除
end




return StateFlag