local ConsoleElementItem = {}

function ConsoleElementItem:Awake(items)
    self.Name       = items["Name"]
    self.Cost       = items["Cost"]
end


function ConsoleElementItem:Init(console_element)
    self.Data       = console_element
    self.Name.text  = console_element.Name

    local cost      = console_element:GetCost()
    if Controller.Data.IsMoneyEnough(cost) == true then
        self.Cost.text  = SetShowNumber(cost) .. "元"
    else
        self.Cost.text  = _C.COLOR.RED .. SetShowNumber(cost) .. "元" .. "</color>"
    end
end


function ConsoleElementItem:OnDestroy()

end


return ConsoleElementItem