--SystemController:系统弹窗

local SystemController = {}

local P = {}


function SystemController.Start()
    UI.Manager:LoadUIWindow(_C.UI.WINDOW.SYSTEMPOPUP,   UI.Manager.TOP)
    
end

function SystemController.FlyTip(text)
    UI.SystemPopupWindow.AddTip(text)
end

function SystemController.ShowNotice(text)
    UI.SystemPopupWindow.ShowNotice(text)
end


function SystemController.Popup(_text, confirm_callback, cancel_callback, is_tip)
    local item = UI.SystemPopupWindow.AddPopup(_text, confirm_callback, cancel_callback)
    item:ShowCancel(is_tip ~= true)

    return item
end

function SystemController.ShowAchievement(achievement_task)
    UI.SystemPopupWindow.ShowAchievement(achievement_task)
end

------------------------------------- Callback -----------------------------



return SystemController