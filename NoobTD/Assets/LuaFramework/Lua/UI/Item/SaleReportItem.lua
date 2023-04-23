local SaleReportItem = {}

function SaleReportItem:Awake(items)
    self.GO         = items["This"]
    self.Bottom     = items["Bottom"]
    self.Name       = items["Name"]
    self.SaleCount  = items["SaleCount"]
    self.Content    = items["Content"]
    self.ScoreTag   = items["ScoreTag"]

    self.Items      = Class.new(Array)

    self:ShowScoreTag(false)
end

function SaleReportItem:GetGame()
    return self.Game
end

function SaleReportItem:Init(game)
    self.Game       = game

    self.Name.text  = game.Name
    local sell_logic= game.GameSellLogic
    self.SaleCount.text  = "销量：" .. SetShowNumber(sell_logic:GetSalesVolume())

    self.Items:Each(function(item)
        destroy(item.GO)
    end)
    self.Items:Clear()
end

function SaleReportItem:FlushUI()
    local game      = self.Game
    local sell_logic= game.GameSellLogic
    local sale_info = sell_logic.SalesInfo

    self.SaleCount.text  = "销量：" .. SetShowNumber(sell_logic:GetSalesVolume())

    local max_value = 0
    local limit     = sell_logic:GetExpectedWeek() * 1.3
    if #sale_info == 1  then
        max_value   = math.max(limit, sale_info[1])
    else
        for i,value in ipairs(sale_info) do
            max_value   = math.max(max_value, value)
        end
        max_value   = math.max(limit, max_value)
    end


    for i,value in ipairs(sale_info) do
        local item  = self.Items:Get(i)
        if item == nil then
            item    = UI.Manager:LoadItem(_C.UI.ITEM.SELLCOUNT, self.Content)
            item:Init(Color.New(56 / 255, 114 / 255, 254 / 255, 1))

            self.Items:Add(item)
        end

        local alpha = 0
        if #sale_info <= 3 then
            alpha   = 1 +  (i - #sale_info) * 0.1
        else
            if #sale_info - i < 3 then
                alpha   = 1.0 + (i - #sale_info) * 0.1
            else
                alpha   = 0.6
            end
        end

        item:SetAlpha(alpha)

        item:UpdateValue(value, max_value)
    end

    local history       = Controller.Data.Account().History
    if history.ScoreGame == self.Game and history.Games:First() ~= self.Game then
        self:ShowScoreTag(true)
    end
end

function SaleReportItem:ShowScoreTag(flag)
    self.ScoreTag:SetActive(flag)
end

function SaleReportItem:OnDestroy()

end


return SaleReportItem