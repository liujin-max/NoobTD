--施法

local Cast = Class.define("Battle.Cast", Battle.Action)

function Cast:ctor(owner, tag)
    super(Battle.Cast, self, "ctor", owner, tag) 
    

end

function Cast:Begin()
    super(Battle.Cast, self, "Begin")

end

function Cast:Update(deltaTime)
    super(Battle.Cast, self, "Update", deltaTime)  


end

function Cast:Terminate()
    super(Battle.Cast, self, "Terminate")  

end

return Cast