--比较简单的计时器, 只看时间是否到点
local CDTimer = Class.define("Logic.CDTimer")


function CDTimer:ctor(total)
    self.Current        = 0
    self.Total          = total
    self.Progress       = 0

end

function CDTimer:Set(current, total)
    self.Current    = current
    self.Total      = total
    self.Progress   = current / total
end

function CDTimer:Reset(replace_total)
    if replace_total ~= nil then
        self.Total = replace_total
    end
    self.Progress   = 0
    self.Current    = 0
end

function CDTimer:LoopReset()
    self.Current    = self.Current - self.Total
    self.Progress   = self.Current / self.Total
end

function CDTimer:SetCurrent(current)
    self.Current    = current
    self.Progress   = self.Current / self.Total
end

function CDTimer:GetCurrent()
    return self.Current
end

function CDTimer:SetTotal(value)
    self.Total = value
end

function CDTimer:GetProgress()
    return self.Progress
end

function CDTimer:GetTotal()
    return self.Total
end

function CDTimer:IsFinished()
    if self.Total < 0 then return false end
    return self.Progress >= 1
end

function CDTimer:Full()
    self.Current = self.Total
    self.Progress= 1
end

function CDTimer:Update(deltaTime)
    if self.Total == 0 then
        self.Progress = 1
    else
        self.Current    = self.Current + deltaTime
        self.Progress   = self.Current / self.Total
    end
end

return CDTimer