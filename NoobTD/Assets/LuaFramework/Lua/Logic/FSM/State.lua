--状态机的状态
State = Class.define("State")

--tag:标识State的名称
function State:ctor(tag, parent)
    self.Tag = tag
    self.Parent = parent
end

function State:SetEntity(parent)
    self.Parent = parent
end

function State:SetBeginFunc(func)
    self._beginFunc = func
end

function State:SetTerminateFunc(func)
    self._terminateFunc = func
end

function State:SetUpdateFunc(func)
    self._updateFunc = func
end

function State:Begin()
    if self._beginFunc ~= nil then
        self._beginFunc(self.Parent)
    end
end

--每个状态的不断更新
function State:Update()
    if self._updateFunc ~= nil then
        self._updateFunc(self.Parent)
    end
end

--状态结束
function State:Terminate()
    if self._terminateFunc ~= nil then
        self._terminateFunc(self.Parent)
    end
end

