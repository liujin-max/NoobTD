--防御塔的行为逻辑

local TowerBehaviour = Class.define("Battle.TowerBehaviour", Battle.Behaviour)

function TowerBehaviour:ctor(owner)
    super(Battle.TowerBehaviour, self, "ctor", owner)    

    self:LoadAction(Battle.Void,        _C.ACTION.VOID)
    self:LoadAction(Battle.Idle,        _C.ACTION.IDLE)
    self:LoadAction(Battle.Cast,        _C.ACTION.CAST)
    self:LoadAction(Battle.Born,        _C.ACTION.BORN)
    self:LoadAction(Battle.Dead,        _C.ACTION.DEAD)

    self:SetInitalAction(self.ACTIONS[_C.ACTION.VOID])
end

function TowerBehaviour:Check()
    super(Battle.TowerBehaviour, self, "Check")
    

    if self.Owner.StateFlag._IsBorn == false then
        if self:CurrentTag() ~= _C.ACTION.BORN then
            self:Transist(_C.ACTION.BORN)
        end
        return
    end

    --死亡
    if self.Owner.StateFlag._IsDead == true then
        if self:CurrentTag() ~= _C.ACTION.DEAD then
            self:Transist(_C.ACTION.DEAD)
        end
        return
    end

    if self:CurrentTag() ~= _C.ACTION.CAST then
        self:Transist(_C.ACTION.CAST)
    end

    if self:CurrentTag() == _C.ACTION.CAST then
        return
    end


end

return TowerBehaviour