local ChartCircleItem = {}

function ChartCircleItem:Awake(items)
    self.GO     = items["This"]
    self.Percent= items["Percent"]
    self.Icon   = self.GO:GetComponent("Image")
end

function ChartCircleItem:Init(game, percent, color)
    self.Icon.color         = color
    self.Icon.fillAmount    = percent

    self.Percent.text       = string.format("%1.f %%", percent * 100)
    self.Percent.gameObject.transform.localEulerAngles  = Vector3.New(0, 0, -self.GO.transform.localEulerAngles.z)

    local angle     = percent * 360 / 2
    local radius    = 280
    local radian    = angle * math.pi / 180
    local x         = math.sin(radian) * radius
    local y         = math.cos(radian) * radius

    self.Percent.gameObject.transform.localPosition = Vector3.New(x, y, 0)
end

function ChartCircleItem:OnDestroy()

end


return ChartCircleItem