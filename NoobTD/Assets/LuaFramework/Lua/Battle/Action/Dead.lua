--死亡

local Dead = Class.define("Battle.Dead", Battle.Action)

function Dead:ctor(owner, tag)
    super(Battle.Dead, self, "ctor", owner, tag) 
    

end

function Dead:Begin()
    super(Battle.Dead, self, "Begin")

    --死亡动画
    
    --播完动画后
    self.Owner.StateFlag._IsGC  = true
end

function Dead:Update(deltaTime)
    super(Battle.Dead, self, "Update", deltaTime)  


end

function Dead:Terminate()
    super(Battle.Dead, self, "Terminate")  

end

return Dead