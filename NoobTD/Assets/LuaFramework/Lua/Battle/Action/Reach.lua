--到达终点

local Reach = Class.define("Battle.Reach", Battle.Action)

function Reach:ctor(owner, tag)
    super(Battle.Reach, self, "ctor", owner, tag) 
    

end

function Reach:Begin()
    super(Battle.Reach, self, "Begin")

    self.Owner.StateFlag._IsGC  = true
end

function Reach:Update(deltaTime)
    super(Battle.Reach, self, "Update", deltaTime)  


end

function Reach:Terminate()
    super(Battle.Reach, self, "Terminate")  

end

return Reach