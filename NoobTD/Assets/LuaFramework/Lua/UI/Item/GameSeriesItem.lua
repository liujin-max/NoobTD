local GameSeriesItem = {}

function GameSeriesItem:Awake(items)
    self.GO         = items["This"]
    self.Name       = items["Name"]
    self.Date       = items["Date"]
    self.Sale       = items["Sale"]
    self.ScorePivot = items["ScorePivot"]
end

function GameSeriesItem:Init(game)
    self.Name.text  = game.Name
    self.Date.text  = "发售： " .. game.GameSellLogic:GetOfferingDateText()
    self.Sale.text  = "销量： " .. SetShowNumber(game.GameSellLogic:GetSalesVolume())

    if self.ScoreItem == nil then
        self.ScoreItem  = UI.Manager:LoadItem(_C.UI.ITEM.GAMESCORE, self.ScorePivot)
    end
    self.ScoreItem:Init(game:GetAvgScore())
end

function GameSeriesItem:OnDestroy()

end


return GameSeriesItem