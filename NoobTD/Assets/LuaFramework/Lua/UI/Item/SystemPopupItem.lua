local SystemPopupItem = {}

function SystemPopupItem:FadeOut()
    self.UIAim:FadeOut(function()
        UI.Manager:UnloadItem(self)
    end)
end

function SystemPopupItem:Awake(items)
    self.GO         = items["This"]
    self.Text       = items["Text"]
    self.Confirm    = items["Confirm"]
    self.Cancel     = items["Cancel"]


    self.UIAim      = self.GO:GetComponent("WindowAnim")
end

function SystemPopupItem:Init(text)
    self.Text.text          = text
end

function SystemPopupItem:ShowCancel(flag)
    self.Cancel:SetActive(flag)    
end

function SystemPopupItem:RegisterConfirmCallback(callback)
    UISimpleEventListener.PGet(self.Confirm,    self.Confirm).onClick_P = function(go)
        if callback then
            callback()
        end
    end
end

function SystemPopupItem:RegisterCancelCallback(callback)
    UISimpleEventListener.PGet(self.Cancel,    self.Cancel).onClick_P = function(go)
        if callback then
            callback()
        end
    end
end

function SystemPopupItem:OnDestroy()

end


return SystemPopupItem