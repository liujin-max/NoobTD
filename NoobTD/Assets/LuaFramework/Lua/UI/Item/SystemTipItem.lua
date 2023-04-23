local SystemTipItem = {}

function SystemTipItem:Awake(items)
    self.GO         = items["This"]
    self.Text       = items["Text"]

    self.Animation  = self.GO:GetComponent("Animation")
end

function SystemTipItem:Init(text)
    self.Text.text          = text
end

function SystemTipItem:Fly()
    self.Animation:Play("SystemTip")
end

function SystemTipItem:OnDestroy()

end


return SystemTipItem