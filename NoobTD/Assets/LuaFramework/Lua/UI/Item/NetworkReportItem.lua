local NetworkReportItem = {}

function NetworkReportItem:Awake(items)
    self.GO         = items["This"]
    self.Bottom     = items["Bottom"]
    self.Name       = items["Name"]
    self.Week       = items["Week"]
    self.CoinCount  = items["CoinCount"]
    self.Content    = items["Content"]


    self.Items      = Class.new(Array)
end

function NetworkReportItem:GetGame()
    return self.Game
end

function NetworkReportItem:Init(game)
    self.Game       = game

    self:FlushText(game)

    self.Items:Each(function(item)
        destroy(item.GO)
    end)
    self.Items:Clear()
end

function NetworkReportItem:FlushText(game)
    local sell_logic= game.GameSellLogic

    self.Name.text      = game.Name
    self.Week.text      = #sell_logic.SalesInfo .. "周"
    self.CoinCount.text = "销售额：" .. SetShowNumber(sell_logic:GetSaleMoney())
end

function NetworkReportItem:FlushUI()
    local game      = self.Game
    local sell_logic= game.GameSellLogic
    local sale_info = sell_logic.SalesInfo

    self:FlushText(game)

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


    local idx   = 1
    for i = 9 , 0, -1 do
        local value     = sale_info[#sale_info - i]
        if value ~= nil then
            local item  = self.Items:Get(idx)
            if item == nil then
                item    = UI.Manager:LoadItem(_C.UI.ITEM.SELLCOUNT, self.Content)
                item:Init(Color.New(255 / 255, 203 / 255, 26 / 255, 1))
                self.Items:Add(item)
            end

            local alpha = 1
            if #sale_info > 3 then
                if i < 3 then
                    alpha   = 1 -  i * 0.1
                else
                    alpha   = 0.6
                end
            end
    
            item:SetAlpha(alpha)
            
            item:UpdateValue(value, max_value)

            idx = idx + 1
        end
    end

end



function NetworkReportItem:OnDestroy()

end


return NetworkReportItem