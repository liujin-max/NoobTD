--游戏评论器
--根据当前游戏得出最终的评论结果

local Evaluator = Class.define("Data.Evaluator")


function Evaluator:GetBase()
    return self.Base
end

function Evaluator:GetScore(evaluator_type)
    return math.max(1, round(self.Scores[evaluator_type] / 100.0))
end

function Evaluator:GetComment(evaluator_type)
    return self.Comments[evaluator_type]
end

function Evaluator:GetAvgScore()
    local count     = 0
    local base      = PairCount(self.Scores)
    for k,v in pairs(self.Scores) do
        count       = count + self:GetScore(k)
    end

    return count / base
end

function Evaluator:GetScores()
    return self.Scores
end

function Evaluator:SyncMSG(msg)
    if msg.Base ~= nil then
        self.Base       = msg.Base
    end

    if msg.Scores ~= nil then
        for _,cfg in ipairs(msg.Scores) do
            self.Scores[cfg.ID] = cfg.Value
        end
    end

    if msg.Comments ~= nil then
        for _,cfg in ipairs(msg.Comments) do
            self.Comments[cfg.ID] = cfg.Value
        end
    end
end

function Evaluator:ctor(game)
    self.Game           = game
    --基础分数
    self.Base           = 0
    self.Scores         = {}
    self.Comments       = {}

end

--影响评分
--1.游戏的各项属性
--2.游戏的类型与主题的相性
function Evaluator:Execute()
    local attribute_max     = _C.CONST.ATTIBUTEMIN
    local attribute_min     = _C.CONST.ATTIBUTEMAX

    --@TODO 2022-02-20 17:30:31 base的算法还需要调整
    local avg_count         = math.max(_C.CONST.GAMESCOREMIN, self.Game:GetAttributeAvg())

    --能力评分
    local base      = 0
    local final     = 0

    if avg_count > 0 then
        base      = math.max(0, math_log(1.9, avg_count) - (1 / math_log(10, avg_count)))
        final     = math.max(_C.CONST.GAMESCOREMIN, base * 100)
    end


    print("测试输出 能力平均分： " .. avg_count ..  " base：" .. base  .. ", final : " .. final)

    self.Base       = final


    local temp          = {}

    table.insert(temp,  self.Game:GetAttribute(_C.ATTRIBUTE.PLAN)    / avg_count)
    table.insert(temp,  self.Game:GetAttribute(_C.ATTRIBUTE.PROGRAM) / avg_count)
    table.insert(temp,  self.Game:GetAttribute(_C.ATTRIBUTE.ARTS)    / avg_count)
    table.insert(temp,  self.Game:GetAttribute(_C.ATTRIBUTE.MUSIC)   / avg_count)

    --(temp[rand] - 1.0) 某项能力值相对平均能力值的比例，映射到评分上
    for _,type in pairs(_C.EVALUATOR) do
        local rand          = Utility.Random.Range(1, #temp)
        local score         = math.max(_C.CONST.GAMESCOREMIN, math.min(_C.CONST.GAMESCOREMAX, final + (temp[rand] - 1.0) * 100))
        self.Scores[type]   = score
        -- print("测试输出 评分 ： " .. type .. ", " .. tostring(score))
        table.remove(temp, rand)
    end

    --评论
    for _,k in pairs(_C.EVALUATOR) do
        local score = self:GetScore(k)
        self.Comments[k] = Controller.Data.Commenter().Filter(self.Game, self, score)
    end
end



return Evaluator