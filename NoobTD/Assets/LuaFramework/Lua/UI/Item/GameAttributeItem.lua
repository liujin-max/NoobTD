
local GameAttributeItem = {}

function GameAttributeItem:Awake(items)
    self.Name       = items["Name"]
    self.Pivot      = items["Pivot"]

    self.Bottom     = self.Pivot:GetComponent("Image")
    self.JumpC      = self.GO:GetComponent("JumpingNumberTextComponent")

    self.Value      = 0
    self.Items      = Class.new(Array)
end

function GameAttributeItem:Init(attribute_type, value)
    self.Name.text  = _C.NAME.ATTRIBUTE[attribute_type]
    self.Value      = value

    self.Bottom.sprite  = AssetManager:LoadSprite("Icon/AttributeIcon/AttributeIcon_item_" .. attribute_type, self.Bottom.gameObject)

    self.Items:Each(function(item)
        UI.Manager:UnLoadCEItem(item)
    end)
    self.Items:Clear()

    self:InitValue(value)
end

function GameAttributeItem:InitValue(value)
    local item = UI.Manager:LoadCEItem()
    item.GO.transform:SetParent(self.Pivot.transform)
    item.GO.transform.localPosition = Vector3.zero
    item.GO.transform.localScale    = Vector3.one
    item:Init(value)

    self.Items:Add(item)
end

function GameAttributeItem:JumpNumber(_ce_now)
    self.Items:Each(function(item)
        UI.Manager:UnLoadCEItem(item)
    end)
    self.Items:Clear()

    self.JumpC:ClearNumbers()

    local ce_origin = math.floor(self.Value)
    local ce_now    = math.floor(_ce_now)

    local ce_o_str  = tostring(ce_origin)
    local ce_n_str  = tostring(ce_now)

    local ce_o_len  = string.len(ce_o_str)
    local ce_n_len  = string.len(ce_n_str)

    local count     = math.max(ce_o_len, ce_n_len)
    local x_table   = {}

    for i = 1, count do
        table.insert(x_table, (i - (count / 2 + 0.5)) * 35)
    end
    
    for i = 0, count - 1 do
        local item = UI.Manager:LoadCEItem()
        item.GO.transform:SetParent(self.Pivot.transform)
        item.GO.transform.localPosition = Vector3.New(x_table[#x_table - i], 0, 0)
        item.GO.transform.localScale    = Vector3.one
        self.JumpC:AddNumber(item.GO:GetComponent("Text"))
        self.Items:Add(item)

        local item = UI.Manager:LoadCEItem()
        item.GO.transform:SetParent(self.Pivot.transform)
        item.GO.transform.localPosition = Vector3.New(x_table[#x_table - i], 50, 0)
        item.GO.transform.localScale    = Vector3.one
        self.JumpC:AddAcNumber(item.GO:GetComponent("Text"))
        self.Items:Add(item)
    end

    self.JumpC:Init()
    self.JumpC:SetNumber(ce_origin, false)
    self.JumpC:Change(ce_origin, ce_now)

    self.Value  = _ce_now
end



function GameAttributeItem:OnDestroy()
    self.Items:Each(function(item)
        UI.Manager:UnLoadCEItem(item)
    end)

    self.Items:Clear()
end


return GameAttributeItem