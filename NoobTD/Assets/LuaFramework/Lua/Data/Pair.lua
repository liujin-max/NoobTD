--二元数据储存
local Pair = Class.define("Data.Pair")

function Pair:ctor(current, total)
    self._Current    = current
    self._Total      = total
end

function Pair:GetCurrent()
    return self._Current
end

function Pair:GetTotal()
    return self._Total
end

function Pair:Clear()
    self._Current   = 0
end

function Pair:UpdateCurrent(v)
    local t = self._Current + v
    self._Current = t
end

function Pair:UpdateTotal(v)
    local t = self._Total + v
    self._Total = t
end

function Pair:SetCurrent(c)
    self._Current = c
end

function Pair:SetTotal(c)
    self._Total = c
end

function Pair:Full()
    return self._Current >= self._Total
end

return Pair