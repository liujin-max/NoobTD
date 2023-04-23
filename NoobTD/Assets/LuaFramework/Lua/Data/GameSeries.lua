--游戏系列

local GameSeries = Class.define("Data.GameSeries")


function GameSeries.GetGameSeriesTop(game)
    if game.SequelBelong == nil then
        return nil
    end
    local games = Controller.Data.Account().History:GetGames()
    local g     = games:Get(game.SequelBelong)
    while g.SequelBelong ~= nil do
        g       = games:Get(g.SequelBelong)
    end
    return g
end

function GameSeries:ctor(order)
    self.Games      = Class.new(Array)

end

function GameSeries:Insert(game)
    self.Games:Add(game)    
end

function GameSeries:GetGames()
    return self.Games
end

function GameSeries:GetName()
    return self.Games:First().Name
end

function GameSeries:GetSalesVolume()
    local value     = 0
    for i = 1, self.Games:Count() do
        local game  = self.Games:Get(i)
        if game.GameSellLogic ~= nil then
            local count = game.GameSellLogic:GetSalesVolume()
            value       = value + count 
        end
    end
    return value
end

function GameSeries:GetOfferDate()
    return self.Games:First().GameSellLogic.OfferingDate
end




return GameSeries