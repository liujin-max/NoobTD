--战场格子 => 终点

local Exit = Class.define("Battle.Exit", Battle.Grid)

function Exit:ctor(land, pos_cfg)
    super(Battle.Exit, self, "ctor", land, pos_cfg)
end



function Exit:Update(deltatime)
    
end



return Exit