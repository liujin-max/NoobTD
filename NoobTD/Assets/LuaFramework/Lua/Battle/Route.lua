--战场格子
-- => 路线格子

local Route = Class.define("Battle.Route", Battle.Grid)

function Route:ctor(land, pos_cfg)
    super(Battle.Route, self, "ctor", land, pos_cfg)

end

function Route:IsEnd()
    
end


return Route