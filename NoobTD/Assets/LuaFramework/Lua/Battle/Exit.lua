--战场格子 => 终点

local Exit = Class.define("Battle.Exit", Battle.Grid)

function Exit:ctor(land, pos_cfg)
    super(Battle.Exit, self, "ctor", land, pos_cfg)

    self.HP = Class.new(Data.Pair, 5, 5)
end

function Exit:Hurt(value)
    self.HP._Current = math.max(0, self.HP._Current - value)
end

--沦陷了
function Exit:IsOccupied()
    return self.HP._Current <= 0
end

function Exit:Update(deltatime)
    
end



return Exit