local StaffItem = {}

function StaffItem:Awake(items)
    self.GO         = items["This"]
    self.Name       = items["Name"]
    self.Job        = items["Job"]
    self.Attribute  = items["Attribute"]

    self.Gray       = self.GO:GetComponent("ImageGray")

end

function StaffItem:Init(staff)
    self.Data       = staff
end



function StaffItem:TurnGray(flag , level)
    if flag == false then
        self.Gray:TurnGray(flag , 0)
    else
        self.Gray:TurnGray(flag , level)
    end
end

function StaffItem:OnDestroy()

end


return StaffItem

