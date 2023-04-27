--Action: 行为动作：攻击、行走、施法等等

local Action = Class.define("Battle.Action")

function Action:ctor(owner, tag)
    self.Owner      = owner
    self.Tag        = tag
    self._Params    = nil
end

function Action:SetParam(param)
    self._Params = param
end

--IsDone: 和Terminate不同, 是指的该状态下的所有需要处理的都处理完了
function Action:IsDone()

end

function Action:Begin()

end

function Action:Update(deltaTime)

end

function Action:Terminate()

end

return Action