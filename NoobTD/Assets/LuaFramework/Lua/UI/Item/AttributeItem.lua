local AttributeItem = {}

function AttributeItem:Awake(items)
    self.GO         = items["This"]
    self.Bottom     = items["Bottom"]
    self.Icon       = items["Icon"]
    self.Count      = items["Count"]
    self.Up         = items["Up"]
    self.ScoreTag   = items["ScoreTag"]

    self:ShowUP(false)
    self:ShowScoreTag(false)
    self:ShowBottom(false)
end

function AttributeItem:Init(attribute_type, score)
    self.Icon.sprite    = AssetManager:LoadSprite("Icon/AttributeIcon/AttributeIcon_" .. attribute_type, self.Icon.gameObject)
    self.Icon:SetNativeSize()

    self.Count.text     = score
end

function AttributeItem:SetScore(score, color)
    if color ~= nil then
        self.Count.text     = color .. score .. "</color>"
    else
        self.Count.text     = score
    end

end

function AttributeItem:ShowUP(flag, is_crit)
    self.Up:SetActive(flag)    

    local img   = self.Up:GetComponent("Image")
    if is_crit == true then
        img.sprite    = AssetManager:LoadSprite("Icon/Universal/Universal_arrow_red", img.gameObject)
    else
        img.sprite    = AssetManager:LoadSprite("Icon/Universal/Universal_arrow_green", img.gameObject)
    end
end

function AttributeItem:ShowScoreTag(flag)
    self.ScoreTag:SetActive(flag)    
end

function AttributeItem:ShowBottom(flag)
    self.Bottom:SetActive(flag)
end

function AttributeItem:ShowCount(flag)
    self.Count.gameObject:SetActive(flag)
end

function AttributeItem:TurnGray(flag)
    self.Bottom.transform:GetComponent("ImageGray"):TurnGray(flag, 1)
    self.Icon.transform:GetComponent("ImageGray"):TurnGray(flag, 1)  
end

function AttributeItem:OnDestroy()

end


return AttributeItem