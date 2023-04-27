--待机

local Idle = Class.define("Battle.Idle", Battle.Action)

function Idle:ctor(owner, tag)
    super(Battle.Idle, self, "ctor", owner, tag) 
    

end

function Idle:Begin()
    super(Battle.Idle, self, "Begin")

end

function Idle:Update(deltaTime)
    super(Battle.Idle, self, "Update", deltaTime)  


end

function Idle:Terminate()
    super(Battle.Idle, self, "Terminate")  

end

return Idle