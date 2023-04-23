ItemBase = {}

function ItemBase.OnCheckRedDot(pself, eventType, item)
    if item.ForceHideRed == true then
        item._RedDotList:Each(function(rd)
            rd:ForceHide()
        end)
        return
    end

    item._RedDotList:Each(function(rd)
        rd:Flush()
    end)
end

--第一个item指代
function ItemBase.PreAwake(entitys, item_class, reddot_array)
    local self = {}
    setmetatable(self, { __index = item_class})

    --红点列表
    self._RedDotList   = Class.new(Array)

    for i = 1, #reddot_array do
        local reddot_comp = reddot_array[i]
        local red_dot = Class.new(UI.RedDot, reddot_comp, reddot_comp.ListenList, self)
        reddot_comp.gameObject:GetComponent("Image"):SetNativeSize()
        self._RedDotList:Add(red_dot)
    end

    LuaEventManager.AddHandler(_E.CHECK_RED_ITEM_DOT_STATUS, ItemBase.OnCheckRedDot, self, self)
    
    self.GO       = entitys["This"]
    self:Awake(entitys)
    entitys = nil
    return self
end

function ItemBase.OnFinal(item)
    LuaEventManager.DelHandler(_E.CHECK_RED_ITEM_DOT_STATUS, ItemBase.OnCheckRedDot, item)
end