local HardwareItem = {}

function HardwareItem:Awake(items)
    self.GO             = items["This"]
    self.Title          = items["Title"]
    self.ProgressBar    = items["ProgressBar"]
    self.Progress       = items["Progress"]

    self.Pivots     = {}
    self.Pivots[_C.ATTRIBUTE.PLAN]      = items["Plan"]
    self.Pivots[_C.ATTRIBUTE.PROGRAM]   = items["Program"] 
    self.Pivots[_C.ATTRIBUTE.ARTS]      = items["Arts"] 
    self.Pivots[_C.ATTRIBUTE.MUSIC]     = items["Music"]

    self.Items      = {}

end

function HardwareItem:Init(hardware)
    self.Data       = hardware
    self.Title.text = hardware.Name

    self:InitAttributeItems(hardware)
    self:FlushUI()
end

function HardwareItem:GetAttributePivot(type)
    return self.Pivots[type]
end

function HardwareItem:InitAttributeItems(hardware)
    local attributes= hardware:GetAttributeShow()

    for i = 1, attributes:Count() do
        local cfg   = attributes:Get(i)
        local item  = self.Items[cfg.Type]
        if item == nil then
            local pivot = self.Pivots[cfg.Type]

            item  = UI.Manager:LoadItem(_C.UI.ITEM.GAMEATTRIBUTE)
            item.GO.transform:SetParent(pivot.transform)
            item.GO.transform.localScale    = Vector3.one
            item.GO.transform.localPosition = Vector3.zero

            self.Items[cfg.Type] = item
        end

        item:Init(_C.NAME.ATTRIBUTE[cfg.Type], cfg.Value)
    end
end

function HardwareItem:FlushUI()
    local hardware  = self.Data

    local progress  = hardware:GetProgress()
    self.ProgressBar.fillAmount = progress
    self.Progress.text          = math.floor(progress * 100) .. "%"


    local string    = ""
    local attributes= hardware:GetAttributeShow()

    for i = 1, attributes:Count() do
        local cfg   = attributes:Get(i)

        local item  = self.Items[cfg.Type]

        if item.Value ~= cfg.Value then
            item:JumpNumber(cfg.Value)
        end
    end

end

function HardwareItem:OnDestroy()

end


return HardwareItem