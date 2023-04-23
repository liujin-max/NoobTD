--游戏相性计算器
--根据游戏的类型和主题，计算出相性加成
--游戏的侧重方向

local Fetter = Class.define("Data.Fetter")


function Fetter.FitterID(game_type, game_theme)
    local fitters   = game_type:GetFitters()
    for fetter_id, temp in pairs(fitters) do
        for _,id in ipairs(temp) do
            if id == game_theme.ID then
                return fetter_id
            end
        end
    end
    logError("未找到相性： 类型" .. game_type.ID .. ", 主题" .. game_theme.ID)
    return _C.FETTER.NORMAL
end

function Fetter:SyncMSG(msg)
    if msg.Score ~= nil then
        self.Score  = msg.Score
    end
end

function Fetter:ctor(game)
    self.ID         = Data.Fetter.FitterID(game.Type, game.Theme)
    self.Type       = game.Type
    self.Theme      = game.Theme
    self.Config     = Table.Get(Table.FitterTable, self.ID)
    self.Name       = self.Config.Name
    self.SpeedBase  = self.Config.SpeedBase
    self.BugBase    = self.Config.BugBase   --bug概率


    self.Score      = Utility.Random.Range(self.Config.Score[1], self.Config.Score[2])
end

--开发速度加成
function Fetter:GetSpeed()
    local base_speed    = self.SpeedBase / 100.0

    return base_speed
end

--基础评分加成
function Fetter:GetScore()
    local score     = self.Score

    return score
end

--bug概率
function Fetter:GetBugBase()
    return self.BugBase
end





return Fetter