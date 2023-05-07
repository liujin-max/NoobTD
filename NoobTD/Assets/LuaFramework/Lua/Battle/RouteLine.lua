--路线
--包含多个路线格子、起点、终点

local RouteLine = Class.define("Battle.RouteLine")

function RouteLine:ctor(land, line_cfg)
    self.Land   = land

    self.TagPos = nil


    local realy_width   = (1080 / Screen.height * Screen.width) / 200.0
    local realy_height  = 1080 / 200.0

    --第一个点
    local first_pos     = Vector3.New(line_cfg.Route[1][1], line_cfg.Route[1][2], 0)
    --
    for i, v in ipairs(line_cfg.Route) do
        local pos_x = v[1]
        local pos_y = v[2]

        local is_confirm    = false
        if first_pos.x < -realy_width then
            --起点在左边
            if pos_x >= -realy_width + 2 then
                is_confirm = true
            end

        elseif first_pos.x > realy_width then
            --起点在右边
            if pos_x <= realy_width - 2 then
                is_confirm = true
            end

        elseif first_pos.y < -realy_height then
            --起点在上面
            if pos_y <= realy_height - 2 then
                is_confirm = true
            end

        elseif first_pos.y > realy_height then
            --起点在下面
            if pos_y >= -realy_height + 2 then
                is_confirm = true
            end
        end

        if is_confirm == true then
            self.TagPos = Vector3.New(pos_x, pos_y, 0)
            break
        end
    end


    --不同的屏幕宽度，起点和终点不同
    local spawn_order   = nil
    local exit_order    = nil
    for i, v in ipairs(line_cfg.Route) do
        if math.abs(v[1]) > realy_width then
            if spawn_order == nil then
                if math.abs(math.abs(v[1]) - realy_width) <= 1 then
                    spawn_order = i
                    break
                end
            end
        end
    end

    for i = #line_cfg.Route, 1, -1 do
        local v = line_cfg.Route[i]
        if math.abs(v[1]) > realy_width then
            if exit_order == nil then
                if math.abs(math.abs(v[1]) - realy_width) <= 1 then
                    exit_order = i
                    break
                end
            end
        end
    end

    if spawn_order == nil then
        spawn_order = 1
    end

    if exit_order == nil then
        exit_order = #line_cfg.Route
    end

    --路线节点
    local last_grid  = nil
    self.Routes = Class.new(Array)

    for i = spawn_order, exit_order do
        local v = line_cfg.Route[i]

        local grid = Class.new(Battle.Route, self, v)
        self.Routes:Add(grid)

        if last_grid ~= nil then
            grid.Distance   = last_grid.Distance + Utility.Battle.Distance(last_grid:CenterPos(), grid:CenterPos())
        end

        last_grid = grid
    end

    --起点
    self.Spawn  = Class.new(Battle.Spawn, self, line_cfg.Route[spawn_order])

    --终点
    self.Exit   = Class.new(Battle.Exit, self, line_cfg.Route[exit_order])
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

function RouteLine:Dispose()
    
end

return RouteLine