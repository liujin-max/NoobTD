local UIManager = {}

UIManager.BOTTOM        = "BOTTOM"
UIManager.MAJOR         = "MAJOR"
UIManager.MAJOR_ABOVE   = "MAJOR_ABOVE"
UIManager.BORAD         = "BORAD"
UIManager.TOP           = "TOP"


local WindowStatus      = {}


local function InitLayer(layers, tag, root)
    layers[tag] = {}
    layers[tag].Pivot = root:Find(tag)
    layers[tag].Stack = Class.new(Stack)  --主要是MAJOR
    layers[tag].Container = Class.new(Array)

    local canvas = layers[tag].Pivot.gameObject:GetComponent("Canvas")
    layers[tag].sortingOrder = canvas.sortingOrder
end

function UIManager:GetSortingOrder(tag)
    return self.Layers[tag].sortingOrder
end

function UIManager.GetWindow(name)
    -- error("WINDOW " .. name .. " " .. tostring(UI[name]))
    return UI[name]
end

function UIManager.GetItem(name)
    return UI[name]
end

function UIManager:SetLayerTransparent(flag, tag)
    local cg = self.Layers[tag].Pivot.gameObject:GetComponent("CanvasGroup")
    if flag == true then
        cg.alpha = 0
    else
        cg.alpha = 1
    end
end

function UIManager:Init()
    self.Canvas         = GameObject.Find("Canvas").transform
    self.SceneCanvas    = GameObject.Find("SceneCanvas").transform

    --Layer: 每一个图层
    self.Layers = {}
    InitLayer(self.Layers, UIManager.BOTTOM,        self.Canvas)
    InitLayer(self.Layers, UIManager.MAJOR,         self.Canvas)
    InitLayer(self.Layers, UIManager.MAJOR_ABOVE,   self.Canvas)
    InitLayer(self.Layers, UIManager.BORAD,         self.Canvas)
    InitLayer(self.Layers, UIManager.TOP,           self.Canvas)
    

    UpdateManager.AddHandler(UIManager)
end

function UIManager:Update(deltaTime)
    
end

function UIManager:StackVisible(go, visibleFlag)
    WindowStatus[go].IsStackVisible = visibleFlag

    if WindowStatus[go].IsVisible and WindowStatus[go].IsStackVisible then
        go.transform.localPosition = Vector3.zero
    else
        go.transform.localPosition = Vector3.New(3000, 0, 0)
    end
end

function UIManager:IsVisible(window)
    if self:IsWindowExist(window.TAG) == false then return false end
    return window.GO.transform.localPosition == Vector3.zero
end

function UIManager:Visible(go, visibleFlag)
    -- if isNull(go) then return end
    WindowStatus[go].IsVisible = visibleFlag

    if WindowStatus[go].IsVisible and WindowStatus[go].IsStackVisible then
        go.transform.localPosition = Vector3.zero
    else
        go.transform.localPosition = Vector3.New(3000, 0, 0)
    end
end


function UIManager:ChildTo(item, parent)
    item.GO.transform:SetParent(parent, true)
end

function UIManager:LoadSceneItem(tag)
    local itemGO = NoobTD.GameFacade.Instance.AssetManager:LoadSync(UI.PrefabList[tag].Path)
    itemGO.transform:SetParent(self.SceneCanvas)
    itemGO.transform.localScale     = Vector3.one
    itemGO.transform.localPosition  = Vector3.zero

    itemGO.transform:SetAsLastSibling()

    local item = itemGO:GetComponent("NoobTD.LuaItems").LuaTable
    assert(item ~= nil, " ITEM NOT FOUND " .. tag)
    item.TAG = tag
    return item
end

function UIManager:LoadItem(tag, parent)
    local itemGO = NoobTD.GameFacade.Instance.AssetManager:LoadSync(UI.PrefabList[tag].Path)
    if parent ~= nil then
        itemGO.transform:SetParent(parent.transform)
    end
    itemGO.transform.localScale     = Vector3.one
    itemGO.transform.localPosition  = Vector3.zero

    local item = itemGO:GetComponent("NoobTD.LuaItems").LuaTable
    assert(item ~= nil, " ITEM NOT FOUND " .. tag)
    item.TAG = tag
    return item
end

local function LoadDirect(self, tag, layer)
    local prefab = UI.PrefabList[tag]
    local go = NoobTD.GameFacade.Instance.AssetManager:LoadSync(prefab.Path)
    if window ~= nil then
        window.Layer = layer
    end

    go.transform:SetParent(self.Layers[layer].Pivot, false)
    go.transform.localScale = Vector3.one
    go.transform.localPosition = Vector3.zero
    return go
end

local function SetOrder(go, layer, prefab, self)
    go.transform:SetParent(self.Layers[layer].Pivot, false)
    go.transform.localScale = Vector3.one
    -- go.transform.localPosition = Vector3.zero

    WindowStatus[go] = {["IsVisible"] = true, ["IsStackVisible"] = true}

    self.Layers[layer].Container:Add(prefab.Class)

    --入队
    if layer == UIManager.MAJOR then
        local top = self.Layers[UIManager.MAJOR].Stack:Top()
        if top ~= nil and top.IsSleep ~= true then      
            -- self:StackVisible(top.GO, false)
        end
        self.Layers[UIManager.MAJOR].Stack:Push(prefab.Class)
    end
end


--增加一个异步加载方法
function UIManager:LoadUIWindowAsync(tag, layer, callback)
    local prefab = UI.PrefabList[tag]
    prefab.Class.TAG = tag

    if prefab.Progress == true then
        prefab.Class.IsProgressLoad = true
        prefab.Class.LoadFinished   = false
        prefab.Class.UnloadFinished = false
    else
        prefab.Class.IsProgressLoad = false
        prefab.Class.LoadFinished   = true
        prefab.Class.UnloadFinished = false
    end

    for i, window in self.Layers[layer].Container:Triverse() do
        if window == prefab.Class then
            return callback(window)
        end
    end

    NoobTD.GameFacade.Instance.AssetManager:LoadAsync(prefab.Path, function(go)
        prefab.Class.Layer = layer
        SetOrder(go, layer, prefab, self)

        if callback ~= nil then
            callback(prefab.Class)
        end

        if prefab.Progress == true then
            prefab.Class.ProgressShow()
        end
    end)
end

function UIManager:IsLayerEmpty(tag)
    return self.Layers[tag].Container:Count() == 0
end

function UIManager:SetSceneRoot(tag, scene_tag)
    UI[tag].SCENE_TAG = scene_tag
    Controller.Scene.AttachUI(scene_tag, tag)
end

--添加UI
function UIManager:LoadUIWindow(tag, layer, callback)
    local prefab = UI.PrefabList[tag]
    
    UI[tag].TAG = tag

    -- print("self.Layers[  ]" .. tostring(prefab.Path))
    for i, window in self.Layers[layer].Container:Triverse() do
        if window == UI[tag] then
            if callback ~= nil then
                callback(UI[tag])
            end
            return
        end
    end

    local go = NoobTD.GameFacade.Instance.AssetManager:LoadSync(prefab.Path)
    UI[tag].Layer = layer
    SetOrder(go, layer, prefab, self)

    if callback ~= nil then
        callback(UI[tag])
    end

    if prefab.Progress == true then
        UI[tag].ProgressShow()
    else
        LuaEventManager.SendEvent(_E.UI_WINDOW_OPEN_READY, nil, UI[tag], tag)
    end

    return
end

local function DirectUnload(go)
    destroy(go)
end

local function UnloadUIGO(window)
    -- if UI.PrefabList[window.TAG].LongLive == true then return end       --无法删除

    if UI.Manager:IsWindowExist(window.TAG) == false then return end 

    local self = UI.Manager
    --出队
    if  self.Layers[UIManager.MAJOR].Container:Contains(window) ~= nil then
        -- self:StackVisible(window.GO, false)
        --如果是栈顶，则必定需要匹配后，然后进行操作
        if window == self.Layers[UIManager.MAJOR].Stack:Top() then
            self.Layers[UIManager.MAJOR].Stack:Pop()
            local top = self.Layers[UIManager.MAJOR].Stack:Top()

            if top ~= nil and top.IsSleep ~= true then
                -- self:StackVisible(top.GO, true)
            end
        --如果不是栈顶，则直接找到进行删除
        else
            self.Layers[UIManager.MAJOR].Stack:Remove(window)
        end
        window.OnDestroy()
        window.OnFinal(window)
        self.Layers[UIManager.MAJOR].Container:Remove(window)
        destroy(window.GO)
        window.GO = nil
    else
        for tag, layer in pairs(self.Layers) do
            if layer.Container:Contains(window) ~= nil then
                layer.Container:Remove(window)
            end
        end
        window.OnDestroy()
        window.OnFinal(window)

        -- error("===== destroy ===== " .. tostring(window.GO))
        destroy(window.GO)
        window.GO = nil
    end
    
    LuaEventManager.SendEvent(_E.UI_WINDOW_CLOSE_OVER, nil, window, window.TAG)

end

function UIManager:UnloadLayer(layer)
    for _, window in self.Layers[layer].Container:Triverse() do
        UnloadUIGO(window)
    end
end

--UnLoadALL:关闭所有界面
function UIManager:UnLoadALL(exlcude)
    for layer_tag, layer in pairs(self.Layers) do
        for i = layer.Container:Count(), 1, -1 do
            local win = layer.Container:Get(i)
            -- print("测试输出 ：" .. win.TAG)
            if exlcude ~= nil and exlcude[win] ~= nil then
                --可以保留
            else
                UnloadUIGO(win)
            end
        end
    end
end

function UIManager:IsWindowExist(tag)
    if tag == nil then return false end   
    return UI[tag]._Exist or false
end

---------------------------------------------------------------------------------------------------

function UIManager:UnloadItem(item)
    destroy(item.GO)
end

--卸载UI
function UIManager:UnLoadWindow(tag)
    if self:IsWindowExist(tag) == true then
        UnloadUIGO(UI[tag])
    end
end

function UIManager:SwitchTo(go, layer)
    go.transform:SetParent(self.Layers[layer].Pivot.transform)
end

function UIManager:ShowLayer(layer, flag)
    self.Layers[layer].Pivot.gameObject:SetActive(flag)
end

function UIManager:RegisterBtnScale(btn)
    UISimpleEventListener.PGet(btn, btn).onDown_P = function()
        btn.transform.localScale    = Vector3.New(0.9, 0.9, 0.9)
    end 
    
    UISimpleEventListener.PGet(btn, btn).onUp_P = function()
        btn.transform.localScale    = Vector3.one
    end    
end



return UIManager