--诞生

local Born = Class.define("Battle.Born", Battle.Action)

function Born:ctor(owner, tag)
    super(Battle.Born, self, "ctor", owner, tag) 
    

end

function Born:Begin()
    super(Battle.Born, self, "Begin")

    self.Owner.Avatar:Decorate()

    self.Owner.StateFlag._IsBorn = true
end

function Born:Update(deltaTime)
    super(Battle.Born, self, "Update", deltaTime)  


end

function Born:Terminate()
    super(Battle.Born, self, "Terminate")  

end

return Born