--运动轨迹
--点对点

local PointTrace = Class.define("Display.PointTrace", Display.Trace)

function PointTrace:ctor(effect, rotate, speed, o_pos, t_pos)
    super(Display.PointTrace, self, "ctor", effect, rotate, speed, o_pos, t_pos)

    self.Type   = _C.TRACE.POINT

    self.LastDistance   = 1000
end

function PointTrace:Update(deltaTime)
    if self:Activated() == false or self:Arrived() == true then return end

    local current   = self.Effect:GetPos()
    local distance  = Utility.Battle.Distance(current, self.EndPos)

    if distance > 0.2 and distance <= self.LastDistance then
        local direction = Utility.Battle.Normalize(self.EndPos - current) * deltaTime * self.Speed
        local move      = current + direction

        self.Effect:SetPos(move)

        self.LastDistance = distance
    else
        self._IsArrived = true
    end

    Utility.Battle.Rotate(self.Rotate, self.Effect, self.Effect:GetPos(), self.EndPos)
end

return PointTrace