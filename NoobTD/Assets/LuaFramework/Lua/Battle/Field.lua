--战场管理类
local Field = Class.define("Battle.Field")


local STATE = {}
STATE.PRELOAD   = 1 --预加载
STATE.PREPARE   = 2 --准备
STATE.PLAY      = 3 --战斗
STATE.RESULT    = 4 --结算



local function InitFSM(self)
    self.FSM = Class.new(FSM)

    local s_PRELOAD = Class.new(State, STATE.PRELOAD,   self)
    local s_PREPARE = Class.new(State, STATE.PREPARE,   self)
    local s_PLAY    = Class.new(State, STATE.PLAY,      self)
    local s_RESULT  = Class.new(State, STATE.RESULT,    self)


    self.FSM:AddState(s_PRELOAD)
    self.FSM:AddState(s_PREPARE)
    self.FSM:AddState(s_PLAY)
    self.FSM:AddState(s_RESULT)

    
    s_PRELOAD:SetBeginFunc(self.PRELOAD_Start)
    s_PRELOAD:SetUpdateFunc(self.PRELOAD_Update)
    s_PRELOAD:SetTerminateFunc(self.PRELOAD_Terminate)
    
    s_PREPARE:SetBeginFunc(self.PREPARE_Start)
    s_PREPARE:SetUpdateFunc(self.PREPARE_Update)
    s_PREPARE:SetTerminateFunc(self.PREPARE_Terminate)

    s_PLAY:SetBeginFunc(self.PLAY_Start)
    s_PLAY:SetUpdateFunc(self.PLAY_Update)
    s_PLAY:SetTerminateFunc(self.PLAY_Terminate)

    s_RESULT:SetBeginFunc(self.RESULT_Start)
    s_RESULT:SetUpdateFunc(self.RESULT_Update)
    s_RESULT:SetTerminateFunc(self.RESULT_Terminate)


    self.FSM:Init(s_PRELOAD)
end

function Field:RegisterHit(h)
    self.Hits:Add(h)
end

function Field:ctor()
    self.Land       = Class.new(Battle.Land, self)
    self.Positioner = Class.new(Battle.Positioner, self)


    --
    self.Hits       = Class.new(Array)
end

function Field:Start()
    InitFSM()

    self.Land:Decorate()
end

function Field:Update(deltatime)
    if self.FSM ~= nil then
        self.FSM:Update(deltatime)
    end
    
    if self.Positioner ~= nil then
        self.Positioner:Update(deltatime)
    end

    if self.Land ~= nil then
        self.Land:Update(deltatime)
    end
end

function Field:CheckResult()
    local lines = Battle.Field.Land:GetLines()
    for i = 1, lines:Count() do
        local line = lines:Get(i)
        if line:IsOccupied() == true then
            return true, _C.BATTLE.RESULT.LOSE
        end
    end

    return false
end

--@region 预加载
function Field:PRELOAD_Start()
    
end

function Field:PRELOAD_Update()
    
end

function Field:PRELOAD_Terminate()
    
end
--@endregion


--@region 准备
function Field:PREPARE_Start()
    
end

function Field:PREPARE_Update()
    
end

function Field:PREPARE_Terminate()
    
end
--@endregion


--@region 战斗阶段
function Field:PLAY_Start()
    
end

function Field:PLAY_Update()
    --结算Hit
    self.Hits:Each(function(h)
        h:Trigger()        
    end)
    self.Hits:Clear()


    local flag, result  = self:CheckResult()
    if flag == true then
        self.FSM:Transist(STATE.RESULT, {Result = result})
    end
end

function Field:PLAY_Terminate()
    
end
--@endregion

--@region 结算阶段
function Field:RESULT_Start()
    print("RESULT_Start ： " .. self.FSM:GetCurrent().Params.Result)
end

function Field:RESULT_Update()
    
end

function Field:RESULT_Terminate()
    
end
--@endregion




function Field:Dispose()
    self.Land:Dispose()

    
    Battle.FIELD    = nil
end

return Field