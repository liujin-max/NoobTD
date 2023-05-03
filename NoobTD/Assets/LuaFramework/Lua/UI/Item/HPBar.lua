--血条

local HPBar = {}

function HPBar:Awake(items)
    self.GO         = items["This"]
    self.White      = items["White"]
    self.Bar        = items["Bar"]

    --动画相关参数
    self.MValue     = nil
    self.TValue     = nil
    self.WValue     = nil   --white
    self.Speed      = nil
end

function HPBar:Init(value, max)
    self.MValue     = max
    self.TValue     = value
    self.WValue     = value

    self.Speed      = max / 0.5 --0.5秒跑完

    self.Bar.fillAmount     = value / max
    self.White.fillAmount   = value / max
end

function HPBar:FlushHP(value, max)
    self.MValue     = max
    self.TValue     = value

    self.Bar.fillAmount     = value / max
end

function HPBar:Update(deltatime)
    if self.WValue ~= self.TValue then
        if self.TValue > self.WValue then
            self.WValue = self.WValue + self.Speed * 0.5 * deltatime

            if self.WValue >= self.TValue then
                self.WValue = self.TValue
            end
        else
            self.WValue = self.WValue - self.Speed * 0.5 * deltatime

            if self.WValue <= self.TValue then
                self.WValue = self.TValue
            end
        end

        self.White.fillAmount = self.WValue / self.MValue
    end
end

function HPBar:OnDestroy()

end


return HPBar