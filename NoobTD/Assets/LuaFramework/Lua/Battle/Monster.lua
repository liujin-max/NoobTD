--怪物

local Monster = Class.define("Battle.Monster")

function Monster:ctor(cfg)
    self.ID     = 900001

    self.SPEED  = 2

    --路线
    self.RouteLine  = nil
    self.RouteIndex = 1
end

function Monster:Decorate()
    self.Avatar = Class.new(Display.Avatar, self)
    self.Avatar:Decorate()
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

function Monster:Update(deltatime)
    --走路逻辑
    local cur_node  = self:GetCurrentRoute()
    local next_node = self:GetNextRoute()

    if next_node == nil then
        return
    end

    local next_pos  = next_node:CenterPos()
    local o_pos     = self.Avatar:GetPosition()
    local dir       = Vector3.Normalize(next_pos - o_pos) * self.SPEED * deltatime
    local to_pos    = o_pos + dir
    self.Avatar:SetPosition(to_pos)

    if Vector3.Distance(next_pos , to_pos) <= 0.1 then
        self.RouteIndex = self.RouteIndex + 1
    end
end



return Monster