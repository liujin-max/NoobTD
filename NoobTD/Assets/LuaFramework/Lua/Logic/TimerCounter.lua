--计时器: Update函数/Finish函数
local TimeCounter = Class.define("Logic.TimeCounter")

function TimeCounter.Register(duration, startFunc, updateFunc, finishFunc)
    local counter = Class.new(TimeCounter, duration)
    counter:SetUpdateFunc(updateFunc)
    counter:SetFinishFunc(finishFunc)
    counter:SetStartFunc(startFunc)
    UpdateManager.RegisterTimer(counter)
    if counter.StartFunc ~= nil then
        counter.StartFunc()
    end
    return counter
end

function TimeCounter:ctor(duration, manualStart)
    self.Current = 0
    if duration == 0 then duration = 0.01 end   --做一个偏移防止出NAN的问题
    self.Duration = duration
    self.ManualStart = manualStart
    self.ForceFinish = false
end

function TimeCounter:SetStartFunc(startFunc)
    self.StartFunc = startFunc
end

function TimeCounter:SetUpdateFunc(updateFunc)
    self.UpdateFunc = updateFunc
end

function TimeCounter:SetFinishFunc(finishFunc)
    self.FinishFunc = finishFunc
end

function TimeCounter:Start()
    self.ManualStart = nil
end

function TimeCounter:Pause()
    self.ManualStart = true
end

function TimeCounter:Finish()
    self.ForceFinish = true
end

function TimeCounter:Update()
    if self.ManualStart ~= nil then return end
    self.Progress = self.Current / self.Duration

    self.Current = self.Current + Time.deltaTime
    --UpdateFunc: 更新函数
    if self.UpdateFunc ~= nil then
        self.UpdateFunc(Time.deltaTime, self)
    end
    --FinishFunc: 结束函数
    if (self.Duration - self.Current) < 0 or self.ForceFinish == true then
        if self.FinishFunc ~= nil then
            self.FinishFunc()
        end
        self.Current = 0
        UpdateManager.UnRegisterTimer(self)
    end
end

return TimeCounter