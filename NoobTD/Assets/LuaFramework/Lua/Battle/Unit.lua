--战场单位

local Unit = Class.define("Battle.Unit")

function Unit:ctor(cfg)
    self.Table      = cfg
    self.ID         = cfg.ID
    self.Name       = cfg.Name


    --@region 属性
    self.HP         = Class.new(Data.Pair, cfg.HP, cfg.HP)
    self.ATK        = Class.new(Data.AttributeValue, cfg.Atk)
    self.SPEED      = Class.new(Data.AttributeValue, cfg.Speed)
    --@endregion

    self.StateFlag  = Class.new(Battle.StateFlag, self)
    self.Behaviour  = nil

    self.Avatar     = Class.new(Display.Avatar, self)
end

function Unit:InitBehaviour()

end

function Unit:IsDead() 
    return self.StateFlag._IsDead
end

function Unit:Dead() 
    self.StateFlag._IsDead  = true
end

function Unit:IsGC()
    return self.StateFlag._IsGC == true
end

function Unit:Update(deltatime)
    if self.Behaviour ~= nil then
        self.Behaviour:Update(deltatime)
    end
end

function Unit:Dispose()
    self.Behaviour  = nil

    self.Avatar:Dispose()
end

return Unit