--游戏销售逻辑

local GameSellLogic = Class.define("Data.GameSellLogic")



local function calculator_price(self)
    local rand  = Utility.Random.Range(200 * 2, 300 * 2) / 100

    if self.Game:IsNetwork() == true then
        rand    = rand * Utility.Random.Range(30 * 2, 45 * 2) / 100.0
    end

    return rand
end

local function fans_price(self)
    local rand  = Utility.Random.Range(230 * 2, 330 * 2) / 100

    if self.Game:IsNetwork() == true then
        rand    = rand * Utility.Random.Range(35 * 2, 50 * 2) / 100.0
    end

    return rand
end

local function TopicRate(game)
    if game:IsNetwork() == false then
        --买断游戏的热度消退逻辑
        return Utility.Random.Range(800,900) / 1000.0
    end
    
    local sell_time_rate = game.GameSellLogic.SellTimes:GetProgress()

    local rate  = 0

    if sell_time_rate <= 0.1 then
        rate    = Utility.Random.Range(990,1040) / 1000.0
    elseif sell_time_rate <= 0.3 then
        rate    = Utility.Random.Range(980,1020) / 1000.0
    elseif sell_time_rate <= 0.8 then
        rate    = Utility.Random.Range(940,1020) / 1000.0
    else
        rate    = Utility.Random.Range(900,980) / 1000.0
    end

    return rate
end


function GameSellLogic:GetOfferingDateText()
    return Controller.Data.Date().DateString(self.OfferingDate)
end

function GameSellLogic:SetOfferingDate(value)
    self.OfferingDate   = value
end

function GameSellLogic:IsSellFinished()
    return self.SellTimes:IsFinished()
end

function GameSellLogic:GetSalesVolume()
    return math.floor(self.SalesVolume)
end

function GameSellLogic:GetExpectedWeek()
    return self.ExpectedWeek
end

function GameSellLogic:GetSaleMoney()
    return math.floor(self.SaleMoney)
end

function GameSellLogic:GetSalesInfo()
    return self.SalesInfo
end

function GameSellLogic:SyncMSG(msg)
    if msg.OfferingDate ~= nil then
        self:SetOfferingDate(msg.OfferingDate)
    end  

    if msg.SalesVolume then
        self.SalesVolume    = msg.SalesVolume
    end

    if msg.SalesInfo ~= nil then
        self.SalesInfo      = msg.SalesInfo
    end

    if msg.SaleMoney ~= nil then
        self.SaleMoney      = msg.SaleMoney
    end

    if msg.SellTimes ~= nil then
        self.SellTimes:Set(msg.SellTimes.Value, msg.SellTimes.Total)
    end

    if msg.Interval ~= nil then
        self.Interval:SetCurrent(msg.Interval)
    end

    if msg.FansBase ~= nil then
        self.FansBase       = msg.FansBase
    end
    
    if msg.ExpectedWeek ~= nil then
        self.ExpectedWeek   = msg.ExpectedWeek
    end

    if msg.TypeAttention ~= nil then
        self.TypeAttention  = msg.TypeAttention
    end

    if msg.ThemeAttention ~= nil then
        self.ThemeAttention = msg.ThemeAttention
    end
end

function GameSellLogic:ctor(game)
    self.Game           = game

    self.OfferingDate   = nil   --发售日期

    self.SalesVolume    = 0     --销量
    self.SalesInfo      = {0}   --记录每个周期的销量

    self.SaleMoney      = 0     --销售额

    
    local count         = game:IsNetwork() == true and _C.CONST.SELLTIMENETWORK or _C.CONST.SELLTIMENORMAL
    self.SellTimes      = Class.new(Logic.CDTimer,  _C.CONST.WEEKSECOND * count)
    self.Interval       = Class.new(Logic.CDTimer,  _C.CONST.WEEKSECOND)



    self.FansBase       = Controller.Data.Fans():GetCount()

    self.TypeAttention  = game.Type:GetAttention()
    self.ThemeAttention = game.Theme:GetAttention()
    print("测试输出 作品关注度：" .. game.Order .. ", " .. self.TypeAttention .. "," .. self.ThemeAttention)

    --预计首周
    self.ExpectedWeek   = self:GetSellCount(_C.CONST.WEEKSECOND)
end

--计算delta_time时间段内的销量
function GameSellLogic:GetSellCount(delta_time)
    local time_rate     = delta_time / self.SellTimes:GetTotal()

    --@region 计算销量

    --根据主机的市场份额，过滤销量
    local game_console  = self.Game.GameConsole
    local share_rate    = game_console:GetShareRate()   --=>1-100

    local people_count  = Controller.Data.GameMarket():GetPeopleMax() --市场人数

    local share_people  = people_count * share_rate / 100   --销量上限

    --根据游戏的关注度，过滤销量
    --游戏发布会影响关注度，同款类型或者同题材的游戏发布的越多，关注度会越低
    local type_atn      = self.TypeAttention
    local theme_atn     = self.ThemeAttention
    share_people        = share_people * ((type_atn + theme_atn) / 200.0)

    --根据游戏评分，过滤销量
    local score_rate    = self.Game:GetScoreRate()
    share_people        = share_people * score_rate

    --根据游戏的热度，过滤销量
    local topic_heat    = self.Game:GetTopicHead()
    local heat_rate     = topic_heat / _C.CONST.TOPICHEADMAX
    share_people        = share_people * heat_rate


    local sell_count    = math.max(1 - Utility.Random.Range(5 , 10) / 100 * #self.SalesInfo, share_people * time_rate)

    --发行商提高销量
    local agent         = self.Game.Agent
    if agent ~= nil then
        local sale_rate = agent:GetSaleRate()
        sell_count      = sell_count * sale_rate
    end

    --
    -- sell_count  = sell_count * 100000
    --

    local fans_count    = 0
    local fans_base     = self.FansBase
    --根据公司的粉丝数，过滤销量
    if self.Game:IsNetwork() == true then
        --每周都会有2%的粉丝会带来加成
        fans_count      = math.ceil(fans_base * 0.03 * delta_time / _C.CONST.WEEKSECOND)
    else
        --8成的粉丝会购买
        --4成粉丝会在发售后的一周内进行购买
        --剩下4成粉丝平摊到剩下的时间段
        if self.SellTimes:GetCurrent() <= _C.CONST.WEEKSECOND then
            fans_count      = math.ceil(fans_base * 0.2 * delta_time / _C.CONST.WEEKSECOND)
        else
            fans_count      = math.ceil(fans_base * 0.6 * time_rate)
        end
    end

    -- print("测试输出 fans_count："  ..  fans_count)

    --@endregion


    return sell_count, fans_count
end

function GameSellLogic:Update(delta_time)
    self.SellTimes:Update(delta_time)
    self.Interval:Update(delta_time)

    --@region 计算销量
    local sell_count , fans_count    = self:GetSellCount(delta_time, self.SellTimes)

    --粉丝增长逻辑
    Controller.Data.Fans():UpdateFansByGame(self.Game, sell_count)

    --普通销售价格
    local sell_money    = calculator_price(self) * sell_count
    Controller.Data.UpdateMoney(sell_money)

    --粉丝销售价格
    local fans_money    = fans_price(self) * fans_count
    Controller.Data.UpdateMoney(fans_money)

    local money_total   = sell_money + fans_money
    local sell_total    = sell_count + fans_count
    self.SalesVolume    = self.SalesVolume + sell_total
    self.SaleMoney      = self.SaleMoney + money_total

    local year      = Controller.Data.Date():GetYear():GetCurrent()
    local current   = Controller.Data.Account().History:GetIncome(year)
    Controller.Data.Account().History:SetIncome(year, current + money_total)

    LuaEventManager.SendEvent(_E.ACHIEVE_TRIGGER, nil,  _C.ACHIEVEMENT.TRIGGER.GAMESELLING, {Game = self.Game})

    self.SalesInfo[#self.SalesInfo] = self.SalesInfo[#self.SalesInfo] + sell_total


    --每周的市场变化
    if self.Interval:IsFinished() == true then
        self.Interval:Reset()

        LuaEventManager.SendEvent(_E.GAME_RELEASE_WEEK, nil, self)


        if self.Game:IsNetwork() == true then
            --网络游戏每周可能产出研究点
            local game_score    = self.Game.Evaluator:GetAvgScore()
            local rand_max      = round(math.log(game_score) * math.log(game_score))
            local rand          = Utility.Random.Range(1, rand_max)
            print("测试输出 随机获得研究点：" .. rand .. ", 范围: " .. rand_max)
            Controller.Data.Account():UpdateResearch(rand)
        else
            --单机游戏的销量会带来市场人数增长
            local last_week_sellcount   = self.SalesInfo[#self.SalesInfo]
            local increase  = round(math_log(1.1, last_week_sellcount) * 100)
            print("测试输出 人数增长：" .. increase)
            Controller.Data.GameMarket():PutPeople(increase)
        end
    
        table.insert(self.SalesInfo, 0)

        --热度变化逻辑
        local rate  = TopicRate(self.Game)
        self.Game:SetTopicHeat(self.Game:GetTopicHead() * rate)

    end
    --@endregion
end


return GameSellLogic