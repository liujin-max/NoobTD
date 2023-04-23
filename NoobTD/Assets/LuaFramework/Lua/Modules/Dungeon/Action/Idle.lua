local Idle = Class.define("Dungeon.Idle", Dungeon.Action)

function Idle:ctor(doer, tag)
    -- print_type(self)
    -- print("=== IDLE ===CTOR " .. self.class.super)
    -- self:super(Dungeon.Idle, "ctor", doer, tag)  
    self.Doer = doer
    self.Tag  = tag
    self.Done = false
end

function Idle:Begin()
    
end

function Idle:Update(deltaTime)

end

function Idle:Terminate()

end

return Idle