--到达终点

local Reach = Class.define("Battle.Reach", Battle.Action)

function Reach:ctor(owner, tag)
    super(Battle.Reach, self, "ctor", owner, tag) 
    

end

function Reach:Begin()
    super(Battle.Reach, self, "Begin")


    Battle.FIELD:Hurt(self.Owner.Demage or 0)

    if self.Owner.Side == _C.SIDE.ATTACK and self.Owner:IsSummon() == false then
        Battle.FIELD:UpdateMonsterNum(-1)
    end
    
    self.Owner.StateFlag._IsGC  = true
end

function Reach:Update(deltaTime)
    super(Battle.Reach, self, "Update", deltaTime)  
end

function Reach:Terminate()
    super(Battle.Reach, self, "Terminate")  

end

return Reach