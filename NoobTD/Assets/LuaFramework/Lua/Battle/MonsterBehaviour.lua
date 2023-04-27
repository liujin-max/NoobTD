--怪物的行为逻辑

local MonsterBehaviour = Class.define("Battle.MonsterBehaviour", Battle.Behaviour)

function MonsterBehaviour:ctor(owner)
    super(Battle.MonsterBehaviour, self, "ctor", owner)    


    self:LoadAction(Battle.Idle,        _C.ACTION.IDLE)
    self:LoadAction(Battle.Walk,        _C.ACTION.WALK)
    self:LoadAction(Battle.Cast,        _C.ACTION.CAST)

    self:SetInitalAction(self.ACTIONS[_C.ACTION.IDLE])
end

function MonsterBehaviour:Check()
    super(Battle.MonsterBehaviour, self, "Check")
    

    -- if Battle.Field:IsBegin() == false then
    --     return
    -- end

    -- if self.Owner.StateFlag._IsDummy == true and self:CurrentTag() ~= _C.ACTION.DUMMY then   
    --     self:Transist(_C.ACTION.DUMMY)
    --     return
    -- end

    -- if self:CurrentTag() == _C.ACTION.DUMMY then
    --     return
    -- end

    -- if self.Owner.StateFlag._IsBorn == false and self:CurrentTag() ~= _C.ACTION.BORN then   --如果没有出生, 进入出生
    --     self:Transist(_C.ACTION.BORN)
    --     return
    -- end

    -- if self:CurrentTag() == _C.ACTION.BORN then
    --     if self:Current():IsDone() == false then
    --         return
    --     end
    -- end

    -- --当前血量小于0
    -- if self.Owner:IsDead() == true and self:CurrentTag() ~= _C.ACTION.DEAD then
    --     self:Transist(_C.ACTION.DEAD)
    -- end

    -- if self:CurrentTag() == _C.ACTION.DEAD then
    --     return
    -- end

    -- --正在释放技能
    -- if self:CurrentTag() == _C.ACTION.CAST then
    --     if self:Current():IsDone() == false then
    --         return
    --     end
    -- end


end

return MonsterBehaviour