require("Logic/FSM/State")
require("Logic/FSM/Transition")
--有限状态机
FSM = Class.define("FSM")

function FSM:ctor()
    --self.Transitions = {}
    self.State  = {}
end

function FSM:AddState(state)
    assert(self.State[state.Tag] == nil, "state already exist: " .. tostring(state.Tag))
    self.State[state.Tag] = state
end

function FSM:Init(state)
    assert(self.State[state.Tag]~= nil, "state should add first")
    self.CurrentState = state
    self.CurrentState:Begin()
end

function FSM:InitByTag(tag, params)
    local nextState = self.State[tag]
    nextState.Params = params
    if nextState == nil then 
        -- print("STATE: ".. tag .. " NOT FOUND") return
    end

    self.CurrentState = nextState
    self.CurrentState:Begin()
end

function FSM:GetCurrent()
    return self.CurrentState
end

function FSM:Get(tag)
    return self.State[tag]
end

function FSM:Transist(tag, params, no_trigger_begin)
    local nextState = self.State[tag]
    nextState.Params = params
    if nextState == nil then 
        -- print("STATE: ".. tag .. " NOT FOUND") return
    end

    if self.CurrentState ~= nil then
        self.CurrentState:Terminate()
    end
    self.CurrentState = nextState

    if no_trigger_begin ~= true then
        self.CurrentState:Begin()
    end
end

function FSM:Update()
    if self.CurrentState == nil then return end
    self.CurrentState:Update()
end

function FSM:TerminateCurrent()
    if self.CurrentState ~= nil then
        self.CurrentState:Terminate()
    end
    self.CurrentState = nil
end

