--怪物

local Monster = Class.define("Battle.Monster", Battle.Unit)

function Monster:ctor(cfg, side)
    super(Battle.Monster, self, "ctor", cfg, side)

    self.ReachDemage    = 1
    
    --路线
    self.RouteLine  = nil
    self.RouteIndex = 1
end

function Monster:SetRouteLine(line)
    self.RouteLine  = line    
end

function Monster:GetRouteLine()
    return self.RouteLine
end

function Monster:SetRouteIndex(value)
    self.RouteIndex = value    
end

function Monster:GetCurrentRoute()
    return self.RouteLine:GetRoute(self.RouteIndex)
end

function Monster:GetNextRoute()
    return self.RouteLine:GetRoute(self.RouteIndex + 1)
end

function Monster:InitBehaviour()
    self.Behaviour  = Class.new(Battle.MonsterBehaviour, self)
end



return Monster