--死亡

local Dead = Class.define("Battle.Dead", Battle.Action)

function Dead:ctor(owner, tag)
    super(Battle.Dead, self, "ctor", owner, tag) 
    

end

function Dead:Begin()
    super(Battle.Dead, self, "Begin")

    self.Timer  = Class.new(Logic.CDTimer, 1.0)
    --死亡动画

    --
    if self.Owner.Side == _C.SIDE.ATTACK and self.Owner:IsSummon() == false then
        Battle.FIELD:UpdateMonsterNum(-1)
    end

    --掉落金币
    if self.Owner.Coin ~= nil then
        Battle.FIELD:UpdateCoin(self.Owner.Coin)
    end
end

function Dead:Update(deltaTime)
    super(Battle.Dead, self, "Update", deltaTime)  

    self.Timer:Update(deltaTime)
    if self.Timer:IsFinished() == true then
        self.Owner.StateFlag._IsGC  = true
    end
end

function Dead:Terminate()
    super(Battle.Dead, self, "Terminate")  

end

return Dead