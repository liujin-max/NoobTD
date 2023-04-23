local SystemPopupWindow = {}
setmetatable(SystemPopupWindow, {__index = WindowBase})

local P     = {}

local Popups        = Class.new(Array)
local TouchMaskElms = Class.new(Array)

local CounterList   = {}

function SystemPopupWindow.Awake(items)
    SystemPopupWindow.PARAMS.Mask           = items["Mask"]
    SystemPopupWindow.PARAMS.Popup          = items["Popup"]
    SystemPopupWindow.PARAMS.Tip            = items["Tip"]
    SystemPopupWindow.PARAMS.TouchMask      = items["TouchMask"]
    SystemPopupWindow.PARAMS.AchievementPivot   = items["AchievementPivot"]
    SystemPopupWindow.PARAMS.NoticePivot    = items["NoticePivot"]
    SystemPopupWindow.PARAMS.MessagePivot   = items["MessagePivot"]

    SystemPopupWindow.PARAMS.Mask:SetActive(false)
    SystemPopupWindow.PARAMS.TouchMask:SetActive(false)

    P.MessageItems  = Class.new(Array)

    LuaEventManager.AddHandler(_E.SYSTEM_TOUCHMASK_UPDATE,  SystemPopupWindow.UpdateTouchMaskElms,  SystemPopupWindow,  SystemPopupWindow)

    
    LuaEventManager.AddHandler(_E.M2U_MESSAGE_PUSH,         SystemPopupWindow.OnPushMessage,        SystemPopupWindow,  SystemPopupWindow)
    LuaEventManager.AddHandler(_E.M2U_MESSAGE_POP,          SystemPopupWindow.OnPopMessage,         SystemPopupWindow,  SystemPopupWindow)
end

function SystemPopupWindow.GetPopups()
    return Popups
end

function SystemPopupWindow.AddPopup(_text, confirm_callback, cancel_callback)
    Popups:Each(function(item)
        item.GO:SetActive(false)
    end)

    local item = UI.Manager:LoadItem(_C.UI.ITEM.SYSTEMPOPUP)
    item.GO.transform:SetParent(SystemPopupWindow.PARAMS.Popup.transform)
    item.GO.transform.localScale    = Vector3.one
    item.GO.transform.localPosition = Vector3.zero
    item:Init(_text)

    item:RegisterConfirmCallback(function()
        if confirm_callback ~= nil then
            confirm_callback()
        end

        SystemPopupWindow.RemovePopup(item)
    end)

    item:RegisterCancelCallback(function()
        if cancel_callback ~= nil then
            cancel_callback()
        end
        SystemPopupWindow.RemovePopup(item)
    end)


    Popups:Add(item)
    SystemPopupWindow.UpdateMask()
    return item
end

function SystemPopupWindow.RemovePopup(item)
    Popups:Remove(item)
    -- destroy(item.GO)
    item:FadeOut()

    if Popups:Count() > 0 then
        local item = Popups:Last()
        item.GO:SetActive(true)
    end

    SystemPopupWindow.UpdateMask()
end

function SystemPopupWindow.UpdateMask()
    Controller.Data.CheckPauseState()
    SystemPopupWindow.PARAMS.Mask:SetActive(Popups:Count() > 0)
end


function SystemPopupWindow.AddTip(_text)
    local item = UI.Manager:LoadItem(_C.UI.ITEM.SYSTEMTIP)
    item.GO.transform:SetParent(SystemPopupWindow.PARAMS.Tip.transform)
    item.GO.transform.localScale    = Vector3.one
    item.GO.transform.localPosition = Vector3.zero
    item:Init(_text)

    item:Fly()

    Logic.TimeCounter.Register(1.2, 
        nil, 
        nil, 
        function()
            destroy(item.GO)
        end
    )
end

function SystemPopupWindow.ShowAchievement(achievement_task)
    local item = UI.Manager:LoadItem(_C.UI.ITEM.ACHIVEMENT, SystemPopupWindow.PARAMS.AchievementPivot.transform)
    item:Init(achievement_task)

    Logic.TimeCounter.Register(3.5, 
        nil, 
        nil,
        function()
            destroy(item.GO)
        end
    )
end

function SystemPopupWindow.ShowNotice(_text)
    local item = UI.Manager:LoadItem(_C.UI.ITEM.NOTICE, SystemPopupWindow.PARAMS.NoticePivot.transform)
    item:Init(_text)

    Logic.TimeCounter.Register(4.5, 
        nil, 
        nil, 
        function()
            destroy(item.GO)
        end
    )
end

function SystemPopupWindow.OnPushMessage(pself, event, message)
    local item  = UI.Manager:LoadItem(_C.UI.ITEM.MESSAGE, SystemPopupWindow.PARAMS.MessagePivot)
    item:Init(message)
    P.MessageItems:Add(item)
end

function SystemPopupWindow:OnPopMessage(pself, event, message)
    for i = P.MessageItems:Count() , 1, -1 do
        local item  = P.MessageItems:Get(i)
        if item.Message == message then
            P.MessageItems:Remove(item)
            destroy(item.GO)
            break
        end
    end    
end


function SystemPopupWindow.UpdateTouchMaskElms(pself, event, go, is_push)
    if is_push == true then
        if TouchMaskElms:Contains(go) == nil then
            TouchMaskElms:Add(go)
        end
    else
        TouchMaskElms:Remove(go)
    end
    -- print("测试输出 ：")
    SystemPopupWindow.PARAMS.TouchMask:SetActive(TouchMaskElms:Count() > 0)
end




function SystemPopupWindow.OnDestroy()
    P   = {}

    Popups:Clear()
    TouchMaskElms:Clear()

    for i, counter in pairs(CounterList) do
        StopCoroutine(counter)
    end
    CounterList = {}

    LuaEventManager.DelHandler(_E.SYSTEM_TOUCHMASK_UPDATE,  SystemPopupWindow.UpdateTouchMaskElms,  SystemPopupWindow)

    LuaEventManager.DelHandler(_E.M2U_MESSAGE_PUSH,         SystemPopupWindow.OnPushMessage,        SystemPopupWindow)
    LuaEventManager.DelHandler(_E.M2U_MESSAGE_POP,          SystemPopupWindow.OnPopMessage,         SystemPopupWindow)
end

return SystemPopupWindow