
local OutsourceAttributeItem = {}

function OutsourceAttributeItem:Awake(items)
    self.Name       = items["Name"]
    self.Pair       = items["Pair"]
    self.Bar        = items["Bar"]
end

function OutsourceAttributeItem:Init(out_source, attribute_type)
    self.Data           = out_source
    self.AttributeType  = attribute_type

    self.Bar.sprite     = AssetManager:LoadSprite("Icon/Outsource/Outsource_item_bar_" .. attribute_type, self.Bar.gameObject )
    self.Name.text      = _C.NAME.ATTRIBUTE[attribute_type]

    self:FlushUI(true)
end

function OutsourceAttributeItem:FlushUI(force)
    local pair      = self.Data:GetAttribute(self.AttributeType)

    local current   = pair:GetCurrent()
    local total     = pair:GetTotal()

    self.Pair.text      = current .. "/" .. total
    -- self.Bar.fillAmount = current / total

    local percent   = current / total

    if force == true then
        self.Bar.fillAmount = percent
    else
        if self.Bar.fillAmount ~= percent then
            -- local offset = percent - self.Bar.fillAmount
            self.Bar.fillAmount = self.Bar.fillAmount + Time.deltaTime
    
            if self.Bar.fillAmount >= percent then
                self.Bar.fillAmount = percent
            end
        end
    end
end






function OutsourceAttributeItem:OnDestroy()

end


return OutsourceAttributeItem