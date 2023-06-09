--运动轨迹

local Trace = Class.define("Display.Trace")



function Trace:ctor(effect, rotate, speed, o_pos, t_pos)
    self.Effect     = effect

    self.Rotate     = rotate
    self.Speed      = speed
    self.StartPos   = o_pos
    self.EndPos     = t_pos


    self._IsArrived = false
    self._Activated = false
end

function Trace:SetEndPos(pos)    
    self.EndPos  = pos
end

function Trace:GO()
    self._Activated = true

    self.Effect:SetPos(self.StartPos)

    Utility.Battle.Rotate(self.Rotate, self.Effect, self.StartPos, self.EndPos)
end

function Trace:Activated()
    return self._Activated
end

--子弹是否到达
function Trace:Arrived()
    return self._IsArrived
end

function Trace:Update(deltaTime)


end

return Trace