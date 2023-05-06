--运动轨迹
--抛物线

local ParabolaTrace = Class.define("Display.ParabolaTrace", Display.Trace)



function ParabolaTrace:ctor(effect, speed, o_pos, t_pos, rotate)
    super(Display.ParabolaTrace, self, "ctor", effect, speed, o_pos, t_pos)

    self.Type   = _C.TRACE.PARABOLA


    self.MidPos         = Utility.Battle.parabola_middle_point(self.StartPos, self.EndPos, 1)

    local distance      = Utility.Battle.Distance(self.StartPos, self.EndPos)

    self.Percent        = 0
    self.ContinueTime   = (Utility.Battle.Distance(self.StartPos, self.MidPos) + Utility.Battle.Distance(self.MidPos, self.EndPos)) / self.Speed
end

function Trace:GO()
    self._Activated = true

    self.Effect:SetPos(self.StartPos)

    Utility.Battle.Rotate(self.Rotate, self.Effect, self.StartPos, self.MidPos)
end

function ParabolaTrace:Update(deltaTime)
    if self:Activated() == false or self:Arrived() == true then return end

    local last_pos  = self.Effect:GetPos()
    local percent   = deltaTime / self.ContinueTime
    self.Percent    = self.Percent + percent

    local next_pos  = Utility.Battle.quardatic_bezier(self.Percent, self.StartPos ,self.EndPos , self.MidPos)
    self.Effect:SetPos(next_pos)

    if self.Percent >= 1 then
        self._IsArrived = true
    end


    Utility.Battle.Rotate(self.Rotate, self.Effect, last_pos, next_pos)
end

return ParabolaTrace