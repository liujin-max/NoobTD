local OutsourceItem = {}


local function NewAttributeItem(self, idx)
    local item = self.Items:Get(idx)
    if item == nil then
        item  = UI.Manager:LoadItem(_C.UI.ITEM.OUTSOURCEATTRIBUTE, self.Pivot.transform)
        self.Items:Add(item)
    end
    item.GO:SetActive(true)
    return item
end

function OutsourceItem:Awake(items)
    self.GO             = items["This"]
    self.Title          = items["Title"]
    self.Pivot          = items["Pivot"]
    self.Progress       = items["Progress"]
    self.ProgressBar    = items["ProgressBar"]


    self.Items          = Class.new(Array)

    LuaEventManager.AddHandler(_E.OUTSOURCE_ADDATTRIBUTE,   self.OnAttributeAdd,    self,   self)
end

function OutsourceItem:Init(out_source)
    self.Data       = out_source
    self.Title.text = out_source.Name

    self:InitAttributeItems(out_source)
    self:FlushUI()
end

function OutsourceItem:InitAttributeItems(out_source)
    self.Items:Each(function(item)
        item.GO:SetActive(false)
    end)

    local attributes= {_C.ATTRIBUTE.PLAN, _C.ATTRIBUTE.PROGRAM, _C.ATTRIBUTE.ARTS, _C.ATTRIBUTE.MUSIC}

    local count     = 1
    for _,type in ipairs(attributes) do
        local pair  = out_source:GetAttribute(type)
        if pair:GetTotal() > 0 then
            local item  = NewAttributeItem(self, count)
            item:Init(out_source, type)

            count   = count + 1
        end
    end
end

function OutsourceItem:FlushUI()
    local out_source    = self.Data
    self.ProgressBar.fillAmount = out_source.CDTimer:GetProgress()

    self.Progress.text  = math.ceil((out_source.CDTimer:GetTotal() - out_source.CDTimer:GetCurrent()) / _C.CONST.WEEKSECOND) .. "周"

    self.Items:Each(function(item)
        item:FlushUI()
    end)
end

function OutsourceItem:OnAttributeAdd(event)
    Logic.MusicPlayer.PlaySound(SOUND.BUBBLEPUSH)
end

function OutsourceItem:OnDestroy()
    LuaEventManager.DelHandler(_E.OUTSOURCE_ADDATTRIBUTE,   self.OnAttributeAdd,    self)
end


return OutsourceItem