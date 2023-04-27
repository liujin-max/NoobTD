--行为: 行为指的是 判断 ----> 行动 的一系列逻辑

local Behaviour = Class.define("Battle.Behaviour")

function Behaviour:ctor(owner)
    self.Owner  = owner

    self._CurrentAction = nil
    self._NextAction    = nil

    self.ACTIONS = {}
end

function Behaviour:Transist(action_tag, param)
    self._NextAction    = self.ACTIONS[action_tag]
    self._NextAction:SetParam(param)

    if self._CurrentAction ~= nil then
        self._CurrentAction:Terminate()
    end

    self._CurrentAction = self._NextAction
    self._NextAction:Begin()
end

--初始行为
function Behaviour:SetInitalAction(action)
    self._CurrentAction = action
end

--当前Action
function Behaviour:Current()
    return self._CurrentAction
end

--当前Action的Tag
function Behaviour:CurrentTag()
    return self._CurrentAction.Tag
end

function Behaviour:LoadAction(action_type, tag)
    self.ACTIONS[tag] = Class.new(action_type, self.Owner, tag)
end

--检查是否需要切换新状态, 其实这个函数才是Behaviour的核心函数, 相当于大脑的存在
function Behaviour:Check()
    
end

function Behaviour:Update(deltaTime)
    self:Check()
    
    self._CurrentAction:Update(deltaTime)
end

return Behaviour