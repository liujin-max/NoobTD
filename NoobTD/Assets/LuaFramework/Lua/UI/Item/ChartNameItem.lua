local ChartNameItem = {}

function ChartNameItem:Awake(items)
    self.GO     = items["This"]
    self.Icon   = items["Icon"]
    self.Name   = items["Name"]
    self.Count  = items["Count"]

end

function ChartNameItem:Init(game, color)
    self.Icon.color = color
    self.Name.text  = game.Name
    self.Count.text = SetShowNumber(game.GameSellLogic:GetSalesVolume()) .. "套"
end

function ChartNameItem:OnDestroy()

end


return ChartNameItem