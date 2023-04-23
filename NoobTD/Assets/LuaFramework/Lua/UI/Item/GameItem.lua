local GameItem = {}

function GameItem:Awake(items)
    self.GO             = items["This"]
    self.Title          = items["Title"]
    self.ProgressBar    = items["ProgressBar"]
    self.Progress       = items["Progress"]
    self.Pivot          = items["Pivot"]

    self.Pivots     = {}
    self.Pivots[_C.ATTRIBUTE.PLAN]      = items["Plan"]
    self.Pivots[_C.ATTRIBUTE.PROGRAM]   = items["Program"] 
    self.Pivots[_C.ATTRIBUTE.ARTS]      = items["Arts"] 
    self.Pivots[_C.ATTRIBUTE.MUSIC]     = items["Music"]
    self.Pivots[_C.ATTRIBUTE.BUG]       = items["Bug"]

    self.Items      = {}
end

function GameItem:GetData()
    return self.Data
end

function GameItem:Init(game)
    self.Data       = game
    self.Title.text = game.Name

    self:InitAttributeItems(game)
    self:FlushUI()
end

function GameItem:GetAttributePivot(type)
    return self.Pivots[type]
end

function GameItem:InitAttributeItems(game)
    for _,item in pairs(self.Items) do
        destroy(item.GO)
    end
    self.Items  = {}

    local attributes= {_C.ATTRIBUTE.PLAN, _C.ATTRIBUTE.PROGRAM, _C.ATTRIBUTE.ARTS, _C.ATTRIBUTE.MUSIC, _C.ATTRIBUTE.BUG}

    for _,type in ipairs(attributes) do
        local item  = self.Items[type]
        if item == nil then
            item    = UI.Manager:LoadItem(_C.UI.ITEM.GAMEATTRIBUTE, self.Pivots[type].transform)
            self.Items[type] = item
        end

        item:Init(type, 0)
    end
end

function GameItem:AddAttribute(attribute_type, value)
    local item  = self.Items[attribute_type]

    local value = item.Value + value
    item:JumpNumber(value)
end

function GameItem:GetAttribute(attribute_type)
    local item  = self.Items[attribute_type]
    return item.Value
end

function GameItem:FlushUI()
    local game      = self.Data

    local progress  = game:GetProgress()
    self.ProgressBar.fillAmount = progress
    self.Progress.text          = math.floor(progress * 100) .. "%"
end

function GameItem:ShowBug(flag)
    self.Pivots[_C.ATTRIBUTE.BUG]:SetActive(flag)
end

function GameItem:OnDestroy()

end


return GameItem