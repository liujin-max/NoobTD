--制造出来的游戏

local Game = Class.define("Data.Game")

--导出一款游戏的存档数据
function Game:ExportGameData()
    local game_table    = {}

    game_table.Order        = self.Order
    game_table.Name         = self.Name
    game_table.Process      = self.Process
    game_table.Progress     = {Value = self.Progress:GetCurrent() , Total = self.Progress:GetTotal()}
    game_table.TopicHeat    = self.TopicHeat
    game_table.SequelBelong = self.SequelBelong
    game_table.Nature       = self.Nature

    game_table.Attributes   = {}
    local attributes    = self.Attributes
    for k,v in pairs(attributes) do
        table.insert(game_table.Attributes, {ID = k, Value = v})
    end

    game_table.Muses    = {}
    local muses         = self.Muses
    for k,v in pairs(muses) do
        table.insert(game_table.Muses,  {ID = k, Value = v})
    end

    game_table.Type     = self.Type.ID
    game_table.Theme    = self.Theme.ID
    game_table.Console  = self.GameConsole.ID

    local fetter        = self.Fetter
    game_table.Fetter   = 
    {
        Score           = fetter:GetScore()
    }

    local agent         = self.Agent
    if agent ~= nil then
        game_table.Agent   = 
        {
            ID           = agent.ID
        }
    end

    game_table.Develop  = {}
    game_table.Develop.Develops = {}
    local develop       = self:GetDevelop()
    local develops      = develop:GetDevelopTable()
    for k,v in pairs(develops) do
        table.insert(game_table.Develop.Develops, {ID = k, Value = v})
    end

    local evaluator     = self.Evaluator
    if evaluator ~= nil then
        game_table.Evaluator            = {}
        game_table.Evaluator.Base       = evaluator:GetBase()

        game_table.Evaluator.Scores     = {}
        local scores    = evaluator:GetScores()
        for k,v in pairs(scores) do
            table.insert(game_table.Evaluator.Scores, {ID = k, Value = v})
        end

        game_table.Evaluator.Comments   = {}
        local comments  = evaluator.Comments
        for k,v in pairs(comments) do
            table.insert(game_table.Evaluator.Comments, {ID = k, Value = v})
        end
    end

    local sell_logic        = self.GameSellLogic
    if sell_logic ~= nil then
        game_table.SellLogic                = {}
        game_table.SellLogic.OfferingDate   = sell_logic.OfferingDate
        game_table.SellLogic.SalesVolume    = sell_logic.SalesVolume
        game_table.SellLogic.SalesInfo      = sell_logic.SalesInfo
        game_table.SellLogic.SaleMoney      = sell_logic.SaleMoney

        game_table.SellLogic.SellTimes      = {Value = sell_logic.SellTimes:GetCurrent(), Total = sell_logic.SellTimes:GetTotal()}
        game_table.SellLogic.Interval       = sell_logic.Interval:GetCurrent()

        game_table.SellLogic.FansBase       = sell_logic.FansBase

        game_table.SellLogic.ExpectedWeek   = sell_logic.ExpectedWeek
        game_table.SellLogic.TypeAttention  = sell_logic.TypeAttention
        game_table.SellLogic.ThemeAttention = sell_logic.ThemeAttention
    end

    game_table.Accident     = {}
    local accident          = self.Accident
    if accident.MediaRecommend ~= nil then
        game_table.Accident.MediaRecommend  = {Current = accident.MediaRecommend:GetCurrent(), Total = accident.MediaRecommend:GetTotal()}
    end

    if accident.MediaHot ~= nil then
        game_table.Accident.MediaHot        = accident.MediaHot
    end

    return game_table
end

function Game:SyncMSG(msg)
    if msg.Order ~= nil then
        self.Order      = msg.Order
    end

    if msg.Name ~= nil then
        self.Name       = msg.Name
    end

    if msg.Process ~= nil then
        self.Process    = msg.Process
    end

    if msg.Progress ~= nil then
        self.Progress:Set(msg.Progress.Value, msg.Progress.Total)
    end

    if msg.TopicHeat ~= nil then
        self.TopicHeat  = msg.TopicHeat
    end

    if msg.Nature ~= nil then
        self.Nature     = msg.Nature
    end

    if msg.Attributes ~= nil then
        for _,v in ipairs(msg.Attributes) do
            self.Attributes[v.ID] = v.Value
        end
    end
    
    if msg.Muses ~= nil then
        for _,v in ipairs(msg.Muses) do
            self.Muses[v.ID] = v.Value
        end
    end

    if msg.SequelBelong ~= nil then
        self.SequelBelong   = msg.SequelBelong
    end


    if msg.Type ~= nil then
        self.Type       = Controller.Data.Menu():GetGameType(msg.Type)
    end    

    if msg.Theme ~= nil then
        self.Theme      = Controller.Data.Menu():GetGameTheme(msg.Theme)
    end

    if msg.Console ~= nil then
        self.GameConsole= Controller.Data.GetGameConsole(msg.Console)
    end

    if msg.Agent ~= nil then
        self.Agent      = Controller.Data.Agentor():GetAgent(msg.Agent.ID)
    end

    if msg.Fetter ~= nil then
        self.Fetter:SyncMSG(msg.Fetter)
    end

    if msg.Develop ~= nil then
        self.Develop:SyncMSG(msg.Develop)
    end

    if msg.Evaluator ~= nil then
        self.Evaluator  = Class.new(Data.Evaluator, self)
        self.Evaluator:SyncMSG(msg.Evaluator)
    end

    if msg.SellLogic ~= nil then
        self.GameSellLogic    = Class.new(Data.GameSellLogic, self)
        self.GameSellLogic:SyncMSG(msg.SellLogic) 
    end

    if msg.Accident ~= nil then
        self.Accident:SyncMSG(msg.Accident)
    end
end

function Game:ctor(order, name, type_id, theme_id, console_id, game_nature)
    self.Order          = order     --序列
    self.Name           = name      --名字
    self.AType          = _C.ATYPE.GAME
    
    self.Type           = Controller.Data.Menu():GetGameType(type_id)       --游戏类型
    self.Theme          = Controller.Data.Menu():GetGameTheme(theme_id)     --游戏主题
    self.GameConsole    = Controller.Data.GetGameConsole(console_id)        --主机
    self.Fetter         = Class.new(Data.Fetter,    self)   --游戏相性
    self.Develop        = Class.new(Data.GameDevelop, self)
    self.Evaluator      = nil       --评分器
    self.GameSellLogic  = nil       --销售器
    self.Agent          = nil       --发行商
    self.Accident       = Class.new(Data.Accident, self)

    self.TopicHeat      = 5
    self.Process        = nil   --开发阶段
    self.Progress       = Class.new(Logic.CDTimer,  1)

    self.Nature         = game_nature or _C.GAME.NATURE.NORMAL       --单机or网游
    
    --4项属性
    self.Attributes     = {}
    self.Attributes[_C.ATTRIBUTE.PLAN]      = 0
    self.Attributes[_C.ATTRIBUTE.PROGRAM]   = 0
    self.Attributes[_C.ATTRIBUTE.ARTS]      = 0
    self.Attributes[_C.ATTRIBUTE.MUSIC]     = 0
    self.Attributes[_C.ATTRIBUTE.BUG]       = 0

    --4项灵感
    self.Muses          = {}
    self.Muses[_C.ATTRIBUTE.PLAN]      = 0
    self.Muses[_C.ATTRIBUTE.PROGRAM]   = 0
    self.Muses[_C.ATTRIBUTE.ARTS]      = 0
    self.Muses[_C.ATTRIBUTE.MUSIC]     = 0
    self.Muses[_C.ATTRIBUTE.BUG]       = 0


    --推广{{ID = 80001} , {}}
    self.Adverts        = {}


    --指向继承的游戏Order
    self.SequelBelong   = nil
end

function Game:NewEvaluator()
    self.Evaluator  = Class.new(Data.Evaluator, self)
    self.Evaluator:Execute()
end

function Game:GetTopicHead()
    return self.TopicHeat
end

function Game:GetDevelop()
    return self.Develop
end

function Game:GetScoreRate()
    local game_score    = self.Evaluator:GetBase()
    local score_rate    = game_score / _C.CONST.GAMESCOREMAX
    return score_rate
end

function Game:GetAttribute(attribute_type)
    return self.Attributes[attribute_type]
end

function Game:GetMuse(attribute_type)
    return self.Muses[attribute_type]
end

function Game:GetAttributeAvg()
    local avg_count         = 0
    local attribute_array   = self:GetAttributeShow()

    for i = 1, attribute_array:Count() do
        local cfg   = attribute_array:Get(i)
        avg_count   = avg_count + cfg.Value
    end
    avg_count       = avg_count / attribute_array:Count()
    return avg_count
end

--是否是续作
function Game:IsSequel()
    return self.SequelBelong ~= nil
end

--是否网络
function Game:IsNetwork()
    return self.Nature == _C.GAME.NATURE.NETWORK
end

function Game:SetName(_name)
    self.Name   = _name    
end

function Game:SetTopicHeat(value)
    self.TopicHeat  = value
end

function Game:SetGameSellLogic(sell_logic)
    self.GameSellLogic = sell_logic
end

function Game:SetProcess(process)
    self.Process        = process
end

function Game:GetProcess()
    return self.Process
end

function Game:SetProgress(value)
    self.Progress:SetCurrent(value)
end

function Game:GetProgress()
    return self.Progress:GetProgress()
end

function Game:AddMuse(attribute_type, value)
    self.Muses[attribute_type] = math.max(0, self.Muses[attribute_type] + value)
end

function Game:SetAttribute(attribute_type, value)
    self.Attributes[attribute_type] = value
end

function Game:AddAttribute(attribute_type, value)
    self.Attributes[attribute_type] = math.max(0, self.Attributes[attribute_type] + value)
end

function Game:GetAttributeShow()
    local array     = Class.new(Array)

    for k,v in pairs(self.Attributes) do
        if k ~= _C.ATTRIBUTE.BUG then
            array:Add({Type = k, Value = v}) 
        end
    end
    array:SortBy("Type", false)
    return array
end

function Game:GetAttributeMin()
    local type  = _C.ATTRIBUTE.PLAN
    local value = 100000
    for k,v in pairs(self.Attributes) do
        if k ~= _C.ATTRIBUTE.BUG then
            if v < value then
                value   = v
                type    = k
            end
        end
    end
    return type
end

function Game:GetAttributeMax()
    local type  = _C.ATTRIBUTE.PLAN
    local value = 0
    for k,v in pairs(self.Attributes) do
        if k ~= _C.ATTRIBUTE.BUG then
            if v > value then
                value   = v
                type    = k
            end
        end
    end
    return type
end

--评价平均分
function Game:GetAvgScore()
    if self.Evaluator == nil then
        return 0
    end
    return self.Evaluator:GetAvgScore()
end

function Game:Update(delta_time)
    if self.Accident ~= nil then
        self.Accident:Update(delta_time)
    end
end

function Game:InAgent()
    if self.Process == _C.GAME.AGENT.START then
        return true
    end

    if self.Process == _C.GAME.AGENT.DOCK then
        return true
    end

    if self.Process == _C.GAME.AGENT.TEST then
        return true
    end

    if self.Process == _C.GAME.AGENT.END then
        return true
    end

    return false
end

--根据类型和主题计算出能力球的上下限
function Game:GeneratorBubbleValue()
    local type_level    = self.Type:GetLevel()
    local theme_level   = self.Theme:GetLevel()

    local value     = math_log(2, type_level + theme_level)
    local min       = math.max(1,   math.floor(value))
    local max       = math.min(_C.CONST.BUBBLEMAX, math.ceil(value))
    local rand      = Utility.Random.Range(min, max)

    return rand
end

--根据类型和主题计算出能力球叠加的概率
function Game:GeneratorBubbleRate()
    local value = self.Type:GetLevel() + self.Theme:GetLevel()
    local base  = 20 + value

    return base
end



return Game