--建造单元

local BuildRingItem = {}

local BuildEffects  = 
{
    Class.new(Logic.EventEffect, 1000, 10000),
    Class.new(Logic.EventEffect, 1000, 20000),
    Class.new(Logic.EventEffect, 1000, 30000),
    Class.new(Logic.EventEffect, 1000, 40000)
}




function BuildRingItem:Awake(items)
    self.GO         = items["This"]
    self.Ring       = items["Ring"]

    self.Items      = Class.new(Array)
end

function BuildRingItem:Init()
    for i, effect in ipairs(BuildEffects) do
        local pivot = self.Ring.transform:Find("P" .. i)

        local item  = UI.Manager:LoadItem(_C.UI.ITEM.BUILD, pivot)
        item:Init(effect)

        self.Items:Add(item)
    end
end

function BuildRingItem:ShowRing(defender)
    for i = 1, self.Items:Count() do
        local item = self.Items:Get(i)

        UIEventListener.PGet(item.GO,  item).onClick_P = function()
            item:Execute(defender)
        end
    end
end

function BuildRingItem:OnDestroy()

end


return BuildRingItem