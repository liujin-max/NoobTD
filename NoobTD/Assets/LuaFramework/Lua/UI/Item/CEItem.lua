local CEItem = {}

function CEItem:Awake(items)
    self.GO     = items["This"]

    self.Text   = self.GO:GetComponent("Text")
end

function CEItem:Init(number)
    self.Text.text  = number
end

function CEItem:OnDestroy()

end


return CEItem