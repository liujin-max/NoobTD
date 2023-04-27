--防御塔的行为逻辑

local TowerBehaviour = Class.define("Battle.TowerBehaviour", Battle.Behaviour)

function TowerBehaviour:ctor(owner)
    super(Battle.TowerBehaviour, self, "ctor", owner)    

    self:LoadAction(Battle.Idle,        _C.ACTION.IDLE)
    self:LoadAction(Battle.Cast,        _C.ACTION.CAST)

    self:SetInitalAction(self.ACTIONS[_C.ACTION.IDLE])
end

function TowerBehaviour:Check()
    super(Battle.TowerBehaviour, self, "Check")
    

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

return TowerBehaviour