local SellCountItem = {}

function SellCountItem:Awake(items)
    self.GO         = items["This"]
    self.Bar        = items["Bar"]

    self.Img        = self.Bar:GetComponent("Image")
end

function SellCountItem:Init(color)
    self.Img.color  = color

    self.Bar.transform.localScale   = Vector3.New(1, 0, 1)
end

function SellCountItem:SetAlpha(value)
    self.GO.name = value
    self.Bar.transform:GetComponent("Image").color  = Color.New(self.Img.color.r, self.Img.color.g, self.Img.color.b, value)
end

function SellCountItem:UpdateValue(value, max)
    if max == 0 then
        self.Bar.transform.localScale   = Vector3.New(1, 0, 1)
        return
    end
    
    local p     = value / max
    self.Bar.transform.localScale   = Vector3.New(1, p, 1)
end

function SellCountItem:OnDestroy()

end


return SellCountItem