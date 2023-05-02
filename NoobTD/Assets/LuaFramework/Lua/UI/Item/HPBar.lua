--血条

local HPBar = {}

function HPBar:Awake(items)
    self.GO         = items["This"]
    self.White      = items["White"]
    self.Bar        = items["Bar"]

    --动画相关参数
    self.MValue     = nil
    self.TValue     = nil
    self.OValue     = nil
    self.Speed      = nil
end

function HPBar:FlushHP(value, max)
    self.MValue     = max
    self.TValue     = value

    if self.Speed == nil then
        self.Speed  = max / 0.5 --0.5秒跑完
    end

    if self.OValue == nil then
        self.OValue = value

        --初始化UI
        self.Bar.fillAmount     = value / max
        self.White.fillAmount   = value / max
    end
end

function HPBar:Update(deltatime)
    if self.OValue ~= self.TValue then
        if self.TValue > self.OValue then
            self.OValue = self.OValue + self.Speed * deltatime

            if self.OValue >= self.TValue then
                self.OValue = self.TValue
            end
        else
            self.OValue = self.OValue - self.Speed * deltatime

            if self.OValue <= self.TValue then
                self.OValue = self.TValue
            end
        end

        self.Bar.fillAmount = self.OValue / self.MValue
    end

    if self.White.fillAmount ~= self.Bar.fillAmount then
        local w_value   = self.White.fillAmount
        local b_value   = self.Bar.fillAmount

        if b_value > w_value then
            w_value = w_value + self.Speed * 1.0 * deltatime / 100.0

            if w_value >= b_value then
                w_value = b_value
            end
        else
            w_value = w_value - self.Speed * 1.0 * deltatime / 100.0

            if w_value <= b_value then
                w_value = b_value
            end
        end

        self.White.fillAmount = w_value
    end
end

function HPBar:OnDestroy()

end


return HPBar