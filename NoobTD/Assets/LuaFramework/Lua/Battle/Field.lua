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

function Field:RegisterBullet(b)
    self.Bullets:Add(b)
end

function Field:UnRegisterBullet(b)
    self.Bullets:Remove(b)
end

function Field:ctor()
    self.Config     = Table.Field[1001]

    self.Coin       = 0 --金币
    self.HP         = Class.new(Data.Pair, 5, 5)
    self.MonsterNum = 0

    self.Land       = Class.new(Battle.Land, self, self.Config)
    self.Positioner = Class.new(Battle.Positioner, self)

    --怪物波数
    self.Waves      = Class.new(Array)
    for i,v in ipairs(self.Config.Waves) do
        local wave  = Class.new(Battle.Wave, v, i)
        self.Waves:Add(wave)

        self.MonsterNum = self.MonsterNum + wave:MonsterCount()
    end

    --
    self.Hits       = Class.new(Array)
    self.Bullets    = Class.new(Array)

    self.PauseFlag  = false
end

function Field:Start()
    InitFSM(self)

    self.Land:Decorate()
end

function Field:Resume()
    self.PauseFlag  = false
end

function Field:Pause()
    self.PauseFlag  = true
end

function Field:IsPause()
    return self.PauseFlag
end

--沦陷了
function Field:IsOccupied()
    return self.HP:GetCurrent() <= 0
end

function Field:GetHP()
    return self.HP:GetCurrent()
end

function Field:Hurt(value)
    self.HP._Current = math.max(0, self.HP._Current - value)
end

function Field:UpdateMonsterNum(value)
    self.MonsterNum = self.MonsterNum + value
end

function Field:GetMonsterCount()
    return self.MonsterNum
end

function Field:CheckResult()
    if self:IsOccupied() == true then
        return true, _C.BATTLE.RESULT.LOSE
    end

    if self.MonsterNum <= 0 then
        return true, _C.BATTLE.RESULT.WIN
    end

    return false
end

function Field:Update(deltatime)
    if self:IsPause() == true then
        return
    end

    if self.FSM ~= nil then
        self.FSM:Update(deltatime)
    end

    if self.Land ~= nil then
        self.Land:Update(deltatime)
    end
end

--@region 预加载
function Field:PRELOAD_Start()
    self.FSM:Transist(STATE.PREPARE)
end

function Field:PRELOAD_Update()
    
end

function Field:PRELOAD_Terminate()
    
end
--@endregion


--@region 准备
function Field:PREPARE_Start()
    UI.Manager:LoadUIWindow(_C.UI.WINDOW.BATTLE, UI.Manager.BOTTOM)
    UI.BattleWindow.Init()

    --加载一个塔
    Logic.Battle.BuildTower(10000, self.Land:GetDefenders():First())
    --
    self.FSM:Transist(STATE.PLAY)
end

function Field:PREPARE_Update()
    local deltatime = Time.deltaTime

    if self.Positioner ~= nil then
        self.Positioner:Update(deltatime)
    end
end

function Field:PREPARE_Terminate()
    
end
--@endregion


--@region 战斗阶段
function Field:PLAY_Start()
    
end

function Field:PLAY_Update()
    local deltatime = Time.deltaTime

    if self.Positioner ~= nil then
        self.Positioner:Update(deltatime)
    end

    --波数
    self.Waves:Each(function(w)
        w:Update(deltatime)
    end)

    --结算Hit
    self.Hits:Each(function(h)
        h:Trigger()        
    end)
    self.Hits:Clear()

    self.Bullets:Each(function(b)
        b:Update(deltatime)        
    end)


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

    UI.Manager:UnLoadWindow(_C.UI.WINDOW.BATTLE)
    
    Battle.FIELD    = nil
end

return Field