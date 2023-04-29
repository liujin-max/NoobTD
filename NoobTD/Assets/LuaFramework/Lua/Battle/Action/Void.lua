--默认

local Void = Class.define("Battle.Void", Battle.Action)

function Void:ctor(owner, tag)
    super(Battle.Void, self, "ctor", owner, tag) 
end

function Void:Begin()
    super(Battle.Void, self, "Begin")
end

function Void:Update(deltaTime)
    super(Battle.Void, self, "Update", deltaTime)  
end

function Void:Terminate()
    super(Battle.Void, self, "Terminate")  
end

return Void