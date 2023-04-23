local MessageItem = {}

function MessageItem:Awake(items)
    self.GO         = items["This"]
    self.Text       = items["Text"]
    self.Emo        = items['Emo']

    self.Animation  = self.GO:GetComponent("Animation")
end

function MessageItem:Init(message)
    self.Text.text  = message.Msg

    if message.Emoji ~= nil then
        --加载特效
        local eff = Display.EffectManager.Add(message.Emoji, self.Emo, Vector3.zero)
        eff.Entity.transform.localScale = eff.Entity.transform.localScale * 0.4 
    end
end

function MessageItem:Show()
    self.Animation:Play("MessageShow")
end

function MessageItem:Hide()
    self.Animation:Play("MessageHide")
end

function MessageItem:OnDestroy()

end


return MessageItem