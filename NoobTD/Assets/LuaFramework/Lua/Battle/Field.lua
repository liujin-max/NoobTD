--战场管理类
local Field = Class.define("Battle.Field")


function Field:ctor()
    self.Land       = Class.new(Battle.Land, self)
    self.Positioner = Class.new(Battle.Positioner, self)



end

function Field:Display()
    self.Land:Display()
end

function Field:Update(deltatime)
    self.Land:Update(deltatime)
    self.Positioner:Update(deltatime)
end

function Field:Dispose()
    self.Land:Dispose()

    
    Battle.FIELD    = nil
end

return Field