--一波怪物
--负责出怪逻辑
--手动出怪
--1波结束后，下一波进入倒计时，在出口显示怪物标记

local Wave = Class.define("Battle.Wave")

local function InitFSM(self)
    self.FSM = Class.new(FSM)

    local s_SILENCE     = Class.new(State, _C.WAVE.STATE.SILENCE,   self)
    local s_COUNTDOWN   = Class.new(State, _C.WAVE.STATE.COUNTDOWN, self)
    local s_SPAWN       = Class.new(State, _C.WAVE.STATE.SPAWN,     self)
    local s_FINISH      = Class.new(State, _C.WAVE.STATE.FINISH,    self)


    self.FSM:AddState(s_SILENCE)
    self.FSM:AddState(s_COUNTDOWN)
    self.FSM:AddState(s_SPAWN)
    self.FSM:AddState(s_FINISH)

    
    s_SILENCE:SetBeginFunc(self.SILENCE_Start)
    s_SILENCE:SetUpdateFunc(self.SILENCE_Update)
    s_SILENCE:SetTerminateFunc(self.SILENCE_Terminate)
    
    s_COUNTDOWN:SetBeginFunc(self.COUNTDOWN_Start)
    s_COUNTDOWN:SetUpdateFunc(self.COUNTDOWN_Update)
    s_COUNTDOWN:SetTerminateFunc(self.COUNTDOWN_Terminate)

    s_SPAWN:SetBeginFunc(self.SPAWN_Start)
    s_SPAWN:SetUpdateFunc(self.SPAWN_Update)
    s_SPAWN:SetTerminateFunc(self.SPAWN_Terminate)

    s_FINISH:SetBeginFunc(self.FINISH_Start)
    s_FINISH:SetUpdateFunc(self.FINISH_Update)
    s_FINISH:SetTerminateFunc(self.FINISH_Terminate)


    self.FSM:Init(s_SILENCE)
end


function Wave:ctor(cfg, order)
    self.Order  = order
    self.Lines  = cfg.line

    self.Timer  = Class.new(Logic.CDTimer, cfg.wait / 100.0)

    self.Exorcists  = Class.new(Array)
    for i,v in ipairs(cfg.list) do
        self.Exorcists:Add({Timer = Class.new(Logic.CDTimer, v.time), ID = v.id})
    end

    InitFSM(self)
end

function Wave:GetOrder()
    return self.Order
end

--怪物数量
function Wave:MonsterCount()
    return self.Exorcists:Count()
end

function Wave:IsSilence()
    return self.FSM:GetCurrent().Tag == _C.WAVE.STATE.SILENCE
end

function Wave:IsCountDown()
    return self.FSM:GetCurrent().Tag == _C.WAVE.STATE.COUNTDOWN
end

function Wave:StartCountDown()
    self.FSM:Transist(_C.WAVE.STATE.COUNTDOWN)
end

--可以手动Start
--或者Timer计时到了，自动Start
function Wave:StartSpawn()
    self.FSM:Transist(_C.WAVE.STATE.SPAWN)
end

--怪物诞生
function Wave:Spawn(cfg)
    local monster   = Class.new(Battle.Monster, Table.Get(Table.MonsterTable, cfg.ID), _C.SIDE.ATTACK)
    local line      = Battle.FIELD.Land:GetLines():First()
    monster:SetRouteLine(line)
    monster:SetRouteIndex(1)
    monster:InitBehaviour()

    Battle.FIELD.Positioner:PushMonster(monster)
end

function Wave:Update(deltatime)
    if self.FSM ~= nil then
        self.FSM:Update()
    end
end

--@region 静默
function Wave:SILENCE_Start()

end

function Wave:SILENCE_Update()
    
end

function Wave:SILENCE_Terminate()
    
end
--@endregion

--@region 倒计时
function Wave:COUNTDOWN_Start()
    LuaEventManager.SendEvent(_E.BATTLE_WP_START, nil, self)
end

function Wave:COUNTDOWN_Update()
    --第一波不会倒计时
    if self.Order == 1 then return end

    self.Timer:Update(Time.deltaTime)
    if self.Timer:IsFinished() == true then
        self:StartSpawn()

        LuaEventManager.SendEvent(_E.BATTLE_WP_COUNTDOWN, nil, self)
    end
end

function Wave:COUNTDOWN_Terminate()
    
end
--@endregion

--@region 产出
function Wave:SPAWN_Start()

end

function Wave:SPAWN_Update()
    local deltatime = Time.deltaTime

    for i = self.Exorcists:Count(), 1, -1 do
        local cfg = self.Exorcists:Get(i)
        cfg.Timer:Update(deltatime)

        if cfg.Timer:IsFinished() == true then
            self:Spawn(cfg)

            self.Exorcists:Remove(cfg)
        end
    end

    if self.Exorcists:Count() == 0 then
        self.FSM:Transist(_C.WAVE.STATE.FINISH)
    end
end

function Wave:SPAWN_Terminate()
    
end
--@endregion


--@region 结束
function Wave:FINISH_Start()

end

function Wave:FINISH_Update()
    
end

function Wave:FINISH_Terminate()
    
end
--@endregion







return Wave