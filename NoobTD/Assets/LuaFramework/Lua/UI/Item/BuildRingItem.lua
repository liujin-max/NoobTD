--建造单元

local BuildRingItem = {}

local BuildEffects  = 
{
    Class.new(Logic.EventEffect, 1000, 10000),
    Class.new(Logic.EventEffect, 1000, 20000),
    Class.new(Logic.EventEffect, 1000, 30000),
    Class.new(Logic.EventEffect, 1000, 40000)
}

local Positions     =
{
    { Vector3.New(  0, 90, 0) },
    { Vector3.New(-90, 90, 0), Vector3.New( 90, 90, 0) },
    { Vector3.New(  0, 90, 0), Vector3.New(-90,  0, 0), Vector3.New( 90,  0, 0) },
    { Vector3.New(-90, 90, 0), Vector3.New( 90, 90, 0), Vector3.New(-90, -90, 0), Vector3.New( 90, -90, 0) }
}

local SellPos   = Vector3.New(  0, -90, 0)

local function get_item(self, i)
    local item  = self.Items:Get(i)
    if item == nil then
        item    = UI.Manager:LoadItem(_C.UI.ITEM.BUILD, self.Ring)
        self.Items:Add(item)
    end
    item.GO:SetActive(true)
    return item
end

function BuildRingItem:Show()
    self.GO:GetComponent("Animation"):Play("ScaleShow")
end

function BuildRingItem:Hide()
    self.GO:GetComponent("Animation"):Play("ScaleHide")
end

function BuildRingItem:Awake(items)
    self.GO         = items["This"]
    self.Ring       = items["Ring"]

    self.Items      = Class.new(Array)
    self.S_ITEM     = nil
end

--展示建造单元
function BuildRingItem:ShowBuilding(defender)
    self.S_ITEM     = nil

    self.Items:Each(function(item)
        item.GO:SetActive(false)
    end)

    local pos_temp= Positions[#BuildEffects]
    for i, effect in ipairs(BuildEffects) do
        local pos = pos_temp[i]

        local item  = get_item(self, i)
        item.GO.transform.localPosition = pos
        item:Init(effect, defender)


        UIEventListener.PGet(item.GO,  item).onClick_P = function()
            if self.S_ITEM  == item then
                self.S_ITEM:Execute()
            else
                if self.S_ITEM ~= nil then
                   self.S_ITEM:Select(false) 
                end

                self.S_ITEM = item
                self.S_ITEM:Select(true)
                self.S_ITEM:Preload()
            end
        end
    end
end

--展示升级单元
function BuildRingItem:ShowUpgrading(defender)
    self.S_ITEM     = nil

    self.Items:Each(function(item)
        item.GO:SetActive(false)
    end)

    local tower     = defender:GetTower()

    local effects   = tower:GetBuildEffects()
    local pos_temp  = Positions[effects:Count()]
    for i = 1, effects:Count() do
        local e     = effects:Get(i)
        local pos   = pos_temp[i]

        local item  = get_item(self, i)
        item.GO.transform.localPosition = pos
        item:Init(e, defender)

        UIEventListener.PGet(item.GO,  item).onClick_P = function()
            if self.S_ITEM  == item then
                self.S_ITEM:Execute()
            else
                if self.S_ITEM ~= nil then
                   self.S_ITEM:Select(false) 
                end

                self.S_ITEM = item
                self.S_ITEM:Select(true)
                self.S_ITEM:Preload()
            end
        end
    end

end

function BuildRingItem:OnDestroy()

end


return BuildRingItem