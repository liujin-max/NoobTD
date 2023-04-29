--运动轨迹

local Trace = Class.define("Display.Trace")

function Trace:ctor(effect, o_pos, t_pos, speed)
    self.Effect     = effect

    self.OPos       = o_pos
    self.ToPos      = t_pos
    self.Speed      = speed


    self._IsArrived = false
    self._Activated = false

    self.Effect:SetPos(o_pos)

    self.LastDistance   = 1000
end

function Trace:GO()
    self._Activated = true

end

--子弹是否到达
function Trace:Arrived()
    return self._IsArrived
end

function Trace:SetToPos(pos)    
    self.ToPos  = pos
end

function Trace:Update(deltaTime)
    if self._Activated == false or self._IsArrived == true then return end

    local current   = self.Effect:GetPos()
    local distance  = Logic.Battle.Distance(current, self.ToPos)

    if distance > 0.2 and distance <= self.LastDistance then
        local direction = Logic.Battle.Normalize(self.ToPos - current) * deltaTime * self.Speed
        local move      = current + direction

        self.Effect:SetPos(move)

        self.LastDistance = distance
    else
        self._IsArrived = true
    end

end

return Trace