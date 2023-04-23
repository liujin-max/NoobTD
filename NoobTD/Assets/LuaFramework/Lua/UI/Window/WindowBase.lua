WindowBase = {}

function WindowBase.PreAwake(window, entitys, reddot_array)
    window.GO        = entitys["This"]
    window._Exist    = true

    --UI区别: 所有临时需要的变量需要定义在这里
    window.PARAMS    = {}

    --红点列表
    window._RedDotList   = Class.new(Array)
    for i = 1, #reddot_array do
        local reddot_comp = reddot_array[i]
        local red_dot = Class.new(UI.RedDot, reddot_comp, reddot_comp.ListenList, window)
        reddot_comp.gameObject:GetComponent("Image"):SetNativeSize()
        window._RedDotList:Add(red_dot)
    end

    LuaEventManager.AddHandler(_E.CHECK_RED_WINDOW_DOT_STATUS, WindowBase.OnCheckRedDot, window, window)

    window.Awake(entitys)
    entitys = nil
end

function WindowBase.OnCheckRedDot(pself, eventType, window, msgs)
    window._RedDotList:Each(function(rd)
        rd:Flush(msgs)
    end)
end

--如果动画逻辑有表现, 则进入Show逻辑
function WindowBase.ProgressShow()
    
end

--如果动画逻辑有表现, 则进入Hide逻辑
function WindowBase.ProgressHide(window, window_tag)
    if UI.Manager:IsWindowExist(window_tag) == false then return end
    
    local component = window.GO:GetComponent("WindowAnim")
    if component ~= nil then
        LuaEventManager.SendEvent(_E.SYSTEM_TOUCHMASK_UPDATE, nil, window, true)

        component:FadeOut(function()
            LuaEventManager.SendEvent(_E.SYSTEM_TOUCHMASK_UPDATE, nil, window, false)
    
            UI.Manager:UnLoadWindow(window_tag)
        end)
    else
        UI.Manager:UnLoadWindow(window_tag)
    end
end

--在OnDestroy之后执行, 标记窗口关闭
function WindowBase.OnFinal(window)
    --UI区别: 关闭时清理变量
    window.PARAMS = nil         
    window._RedDotList:Clear()
    LuaEventManager.DelHandler(_E.CHECK_RED_WINDOW_DOT_STATUS, WindowBase.OnCheckRedDot, window)
    window._Exist    = false
end