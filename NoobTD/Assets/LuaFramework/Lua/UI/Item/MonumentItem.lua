local MonumentItem = {}

function MonumentItem:Awake(items)
    self.Name       = items["Name"]
    self.Money      = items["Money"]
end

function MonumentItem:Init(company)
    self.Name.text  = company:GetName()
    self.Money.text = company:GetMoneyText()
end

function MonumentItem:OnDestroy()

end


return MonumentItem