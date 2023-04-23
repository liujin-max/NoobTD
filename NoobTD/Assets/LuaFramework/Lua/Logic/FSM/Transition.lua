--状态迁移
Transition = Class.define("Transition")

--给两个状态
function Transition:ctor(state_from, state_to, eva_func)
    self.From   = state_from
    self.To     = state_to
    self.EvaluateFunc = eva_func
end

function Transition:Evaluate()
    if self.EvaluateFunc == nil then
        return true
    else
        return self.EvaluateFunc()
    end
end