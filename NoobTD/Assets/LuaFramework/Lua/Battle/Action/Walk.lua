--走路

local Walk = Class.define("Battle.Walk", Battle.Action)

function Walk:ctor(owner, tag)
    super(Battle.Walk, self, "ctor", owner, tag) 
    

end

function Walk:Begin()
    super(Battle.Walk, self, "Begin")

    --行走动画？
end

function Walk:Update(deltaTime)
    super(Battle.Walk, self, "Update", deltaTime)  

    local cur_node  = self.Owner:GetCurrentRoute()
    local next_node = self.Owner:GetNextRoute()

    if next_node == nil then
        return
    end

    local next_pos  = next_node:CenterPos()
    local o_pos     = self.Owner.Avatar:GetPosition()
    local dir       = Vector3.Normalize(next_pos - o_pos) * self.Owner:GetSPEED() * deltaTime
    local to_pos    = o_pos + dir
    self.Owner.Avatar:SetPosition(to_pos)

    if Vector3.Distance(next_pos , to_pos) <= 0.1 then
        self.Owner.RouteIndex = self.Owner.RouteIndex + 1

        local line  = self.Owner:GetRouteLine()
        if line:IsRouteEnd(self.Owner:GetCurrentRoute()) == true then   --到达终点
            self.Owner.StateFlag._IsReach = true
        end
    end
end

function Walk:Terminate()
    super(Battle.Walk, self, "Terminate")  

end

return Walk