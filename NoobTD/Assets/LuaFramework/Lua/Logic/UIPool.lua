
--UI缓存池

local UIPool    = Class.define("Logic.UIPool")


function UIPool:ctor()
    UIPool.POOL     = GameObject.Find("UIPOOL")
    
    self.CEs        = Class.new(Array)
    self.Points     = Class.new(Array)
end

--@region CE
function UIPool:AllocateCEItem()
    local item  = UI.Manager:LoadItem(_C.UI.ITEM.CE)
    return item
end

function UIPool:RecycleCEItem(item)
    destroy(item.GO)
end
--@endregion

--@region Point
function UIPool:AllocatePoint()
    local item  = self.Points:First()
    if item ~= nil then
        item.GO:SetActive(true)
        self.Points:Remove(item)
        return item
    end

    item  = UI.Manager:LoadItem(_C.UI.ITEM.POINT)
    return item
end

function UIPool:RecyclePoint(item)
    if self.Points:Contains(item)  ~= nil then
        Util.LogError("===========POOL RECYCLE Points Duplicate ====== ")
        return
    end

    item.GO.transform:SetParent(UIPool.POOL.transform)
    item.GO.transform.localPosition = Vector3.zero
    item.GO:SetActive(false)

    self.Points:Add(item)
end

--@endregion


return UIPool