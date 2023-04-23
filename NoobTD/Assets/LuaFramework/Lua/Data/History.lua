--开发历史

local History = Class.define("Data.History")


function History:SyncMSG(msg)
    if msg.Consoles ~= nil then
        self.Consoles:Clear()

        for _,config in ipairs(msg.Consoles) do
            local console   = Class.new(Data.GameConsole, config)
            console.IsOurBuild    = true
            console:SyncMSG(config)
            self.Consoles:Add(console)
        end
    end

    
    if msg.Games ~= nil then
        self.Games:Clear()
        for _, cfg in ipairs(msg.Games) do
            local game  = Controller.Data.Factory().CreateGameByTableData(cfg)
            game:SyncMSG(cfg)

            self.Games:Add(game)

            if msg.ScoreGame ~= nil and msg.ScoreGame == game.Order then
                self.ScoreGame  = game
            end
        end

        self.Games:SortBy("Order", false)
    end   

    
    if msg.Scores ~= nil then
        for _,cfg in ipairs(msg.Scores) do
            self.Scores[cfg.ID] = cfg.Value
        end
    end

    if msg.SequelCum ~= nil then
        self.SequelCum  = msg.SequelCum
    end

    if msg.SequelGames ~= nil then
        self.SequelGames:Clear()
        for _,cfg in ipairs(msg.SequelGames) do
            local game  = self.Games:Get(cfg.Order)
            self.SequelGames:Add(game)
        end
    end

    if msg.BuildTypes ~= nil then
        self.BuildTypes = {}
        for _,cfg in ipairs(msg.BuildTypes) do
            self.BuildTypes[cfg.ID] = cfg.Count
        end
    end

    if msg.Incomes ~= nil then
        self.Incomes    = {}
        for _,cfg in ipairs(msg.Incomes) do
            self.Incomes[cfg.ID] = cfg.Value
        end
    end
end

function History:ctor()
    --过往创建过的游戏们
    self.Games          = Class.new(Array)

    --各种类型游戏的制作数量
    self.BuildTypes     = {}
    --每年销售游戏所获得的收入
    self.Incomes        = {}


    --可以制作续作的游戏们
    self.SequelCum      = 0
    self.SequelGames    = Class.new(Array)

    --销售记录
    self.ScoreGame  = nil

    --游戏4项属性的记录
    self.Scores     = {}
    self.Scores[_C.ATTRIBUTE.PLAN]      = 0
    self.Scores[_C.ATTRIBUTE.PROGRAM]   = 0
    self.Scores[_C.ATTRIBUTE.ARTS]      = 0
    self.Scores[_C.ATTRIBUTE.MUSIC]     = 0

    --过往创建过的主机们
    self.Consoles       = Class.new(Array)
end

function History:GetBuildType(type_id)
    local value   = self.BuildTypes[type_id]
    if value == nil then
        return 0
    end
    return value
end

function History:GetIncome(year)
    local count     = self.Incomes[year]
    if count == nil then
        return 0
    end
    return count
end

function History:SetIncome(year, value)
    self.Incomes[year]  = value
end



function History:GetNetworkCount()
    local count = 0
    for i = 1, self.Games:Count() do
        local g = self.Games:Get(i)
        if g:IsNetwork() == true then
            count   = count + 1
        end
    end
    return count
end

function History:InsertGame(game)
    self.Games:Add(game)

    if self.ScoreGame == nil then
        self.ScoreGame = game
    end
    self.Games:SortBy("Order", false)

    if self.BuildTypes[game.Type.ID] == nil then
        self.BuildTypes[game.Type.ID]   = 0
    end
    self.BuildTypes[game.Type.ID]   = self.BuildTypes[game.Type.ID] + 1
end

function History:GetGames()
    return self.Games
end

function History:GetGameCount()
    return self.Games:Count()
end

function History:GetGame(order)
    return self.Games:Get(order)    
end

function History:GetScore(attribute_type)
    return self.Scores[attribute_type]
end

function History:InsertConsole(game_console)
    self.Consoles:Add(game_console)

    self.Consoles:SortBy("ID", false)
end

function History:GetConsole(id)
    return self.Consoles:Get(id)    
end

function History:GetConsoles()
    return self.Consoles
end


function History:CheckSequelGame(game)
    if game:IsNetwork() == true then return end

    local avg   = game:GetAvgScore()
    -- print("测试输出 avg : " .. avg)
    if avg >= 8.2 then
        self.SequelGames:Add(game)
        self.SequelCum  = self.SequelCum + 1

        LuaEventManager.SendEvent(_E.GAME_SEQUEL_CHECK, nil, game)
    end    
end

function History:GetSequelGames()
    return self.SequelGames
end

function History:RemoveSequelGame(game)
    if self.SequelGames:Contains(game) == nil then
        logError("SequelGames not Contains : " .. game.Order)
        return
    end    

    self.SequelGames:Remove(game)
end

function History:UpdateScores(game)
    for attribute_type, value in pairs(self.Scores) do
        local count     = math.max(value, game:GetAttribute(attribute_type))
        self.Scores[attribute_type] = count
    end
end

function History:Update(delta_time)
    for i = 1, self.Games:Count() do
        local game  = self.Games:Get(i)
        if game:IsNetwork() == false then
            local sell_logic= game.GameSellLogic
            if sell_logic ~= nil then
                if sell_logic:GetSalesVolume() > self.ScoreGame.GameSellLogic:GetSalesVolume() then
                    local old_game  = self.ScoreGame
                    self.ScoreGame  = game
                    LuaEventManager.SendEvent(_E.NEWS_GAMESCORE, nil, game , old_game)
                end
            end
        end
    end
end



return History