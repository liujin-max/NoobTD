--负责游戏的发行逻辑

local Publisher = Class.define("Data.Publisher")


local function InitFSM(self)
    self.FSM                = Class.new(FSM)
    
    local s_START           = Class.new(State, _C.GAME.RELEASE.START,       self)
    local s_SCORE           = Class.new(State, _C.GAME.RELEASE.SCORE,       self)
    local s_SELL            = Class.new(State, _C.GAME.RELEASE.SELL,        self)
    local s_END             = Class.new(State, _C.GAME.RELEASE.END,         self)


    self.FSM:AddState(s_START)
    self.FSM:AddState(s_SCORE)
    self.FSM:AddState(s_SELL)
    self.FSM:AddState(s_END)


    s_START:SetBeginFunc(self.START_Start)
    s_START:SetUpdateFunc(self.START_Update)
    s_START:SetTerminateFunc(self.START_End)

    s_SCORE:SetBeginFunc(self.SCORE_Start)
    s_SCORE:SetUpdateFunc(self.SCORE_Update)
    s_SCORE:SetTerminateFunc(self.SCORE_End)

    s_SELL:SetBeginFunc(self.SELL_Start)
    s_SELL:SetUpdateFunc(self.SELL_Update)
    s_SELL:SetTerminateFunc(self.SELL_End)


    s_END:SetBeginFunc(self.END_Start)
    s_END:SetUpdateFunc(self.END_Update)
    s_END:SetTerminateFunc(self.END_End)
end

function Publisher:ctor(game, releaser)
    self.ActingGame     = game   --正在销售的游戏
    self.Releaser       = releaser

    
    InitFSM(self)

    LuaEventManager.AddHandler(_E.DATE_FINISH_WEEK, self.DateWeekFinish,    self,   self)
end

function Publisher:DateWeekFinish(event)
    if self.FSM:GetCurrent().Tag ==  _C.GAME.RELEASE.SCORE  then
        self.FSM:Transist(_C.GAME.RELEASE.SELL)
    end
end

function Publisher:Start()
    self.FSM:InitByTag(_C.GAME.RELEASE.START)
end

function Publisher:TransistFSM(process_tag, params, no_trigger_begin)
    self.FSM:Transist(process_tag , params, no_trigger_begin)
end

function Publisher:GetActingGame()
    return self.ActingGame
end

function Publisher:Update(deltaTime)
    if self.FSM ~= nil then
        self.FSM:Update()
    end

    if self.ActingGame ~= nil then
        self.ActingGame:Update(deltaTime)
    end
end

--@region 开始阶段
function Publisher:START_Start()
    self.ActingGame:SetProcess(self.FSM:GetCurrent().Tag)

    --为自研主机开发游戏，可以提高他的市场占有率
    --以提高主机的能力值的办法来实现此逻辑
    if self.ActingGame.GameConsole:IsOwn() == true then
        for i = _C.ATTRIBUTE.PLAN , _C.ATTRIBUTE.MUSIC do
            local game_atr      = self.ActingGame:GetAttribute(i)
            local console_atr   = self.ActingGame.GameConsole:GetAttribute(i)

            if game_atr > (console_atr * 1.5) then
                local offset    = game_atr - (console_atr * 1.5)

                self.ActingGame.GameConsole:AddAttribute(i, offset * 0.2)
            end
        end
    end

    self.FSM:Transist(_C.GAME.RELEASE.SCORE)
end

function Publisher:START_Update()

end

function Publisher:START_End()
    
end
--@endregion


--@region 展示评分阶段
function Publisher:SCORE_Start()
    self.ActingGame:SetProcess(self.FSM:GetCurrent().Tag)

    -- self.ActingGame:NewEvaluator()

    UI.Manager:LoadUIWindow(_C.UI.WINDOW.GAMESCORE, UI.Manager.BORAD)
    UI.GameScoreWindow.Init(self.ActingGame.Evaluator, function()
        UI.GameScoreWindow.ProgressHide(UI.GameScoreWindow,_C.UI.WINDOW.GAMESCORE)
    end)
end

function Publisher:SCORE_Update()
    
end

function Publisher:SCORE_End()
    -- LuaEventManager.SendEvent(_E.ACHIEVE_TRIGGER, nil, _C.ACHIEVEMENT.TRIGGER.GAMESCORE, {})

    --@TODO 2022-04-13 22:37:06 游戏的评分、能力值 对游戏热度加成
    --评分百分比
    local score_rate    = self.ActingGame:GetScoreRate()
    local score_heat    = score_rate * 50
    print("测试输出 评分加成热度： " .. score_heat)

    --能力值平均分
    local attribute_avg = self.ActingGame:GetAttributeAvg()
    local attribute_heat= attribute_avg / 10.0

    print("测试输出 能力值加成热度： " .. attribute_heat)

    self.ActingGame:SetTopicHeat(attribute_heat + score_heat)
end
--@endregion

--@region 发行阶段
function Publisher:SELL_Start()
    self.ActingGame:SetProcess(self.FSM:GetCurrent().Tag)

    local sell_logic    = Class.new(Data.GameSellLogic, self.ActingGame)
    sell_logic:SetOfferingDate(Controller.Data.Date():GetDate())
    self.ActingGame:SetGameSellLogic(sell_logic)

    Controller.Data.Account().History:CheckSequelGame(self.ActingGame)

    self.ActingGame.Accident:OnReleaseStart()

    LuaEventManager.SendEvent(_E.GAME_RELEASE_START, nil , self.ActingGame)
end

function Publisher:SELL_Update()
    local sell_logic    = self.ActingGame.GameSellLogic
    sell_logic:Update(Time.deltaTime)

    LuaEventManager.SendEvent(_E.GAME_RELEASE_SHOW, nil, self.ActingGame)

    if sell_logic:IsSellFinished() then
        self.FSM:Transist(_C.GAME.RELEASE.END)
    end
end

function Publisher:SELL_End()
    LuaEventManager.SendEvent(_E.GAME_RELEASE_END, nil , self.ActingGame)
end
--@endregion

--@region 结束
function Publisher:ForceEnd()
    self.FSM:Transist(_C.GAME.RELEASE.END)
end

function Publisher:END_Start()
    self.ActingGame:SetProcess(self.FSM:GetCurrent().Tag)


    self.FSM:TerminateCurrent()
end

function Publisher:END_Update()
    
end

function Publisher:END_End()

    self.ActingGame = nil

    self.Releaser:Remove(self)

    LuaEventManager.DelHandler(_E.DATE_FINISH_WEEK, self.DateWeekFinish,    self)
end
--@endregion


return Publisher