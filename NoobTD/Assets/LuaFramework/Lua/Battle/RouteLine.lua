--路线
--包含多个路线格子、起点、终点

local RouteLine = Class.define("Battle.RouteLine")

function RouteLine:ctor(land, line_cfg)
    self.Land   = land

    --路线节点
    local last_grid  = nil
    self.Routes = Class.new(Array)
    for i, v in ipairs(line_cfg.Route) do
        local grid = Class.new(Battle.Route, self, v)
        self.Routes:Add(grid)

        if last_grid ~= nil then
            grid.Distance   = last_grid.Distance + Logic.Battle.Distance(last_grid:CenterPos(), grid:CenterPos())
        end

        last_grid = grid
    end

    --起点
    self.Spawn  = Class.new(Battle.Spawn, self, line_cfg.Spawn)

    --终点
    self.Exit   = Class.new(Battle.Exit, self, line_cfg.Exit)
end

function RouteLine:GetRoute(index)
    return self.Routes:Get(index)    
end

function RouteLine:IsRouteEnd(route)
    return self.Routes:IndexOf(route) == self.Routes:Count()    
end

function RouteLine:GetExit()
    return self.Exit
end

function RouteLine:IsOccupied()
    return self.Exit:IsOccupied()
end

function RouteLine:Dispose()
    
end

return RouteLine