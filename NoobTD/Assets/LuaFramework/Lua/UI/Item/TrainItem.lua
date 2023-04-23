local TrainItem = {}

function TrainItem:Awake(items)
    self.Name       = items["Name"]
    self.Cost       = items["Cost"]
    self.BtnCost    = items["BtnCost"]

    self.Objs                       = {}
    self.Objs[_C.ATTRIBUTE.PLAN]    = items["Plan"]
    self.Objs[_C.ATTRIBUTE.PROGRAM] = items["Program"]
    self.Objs[_C.ATTRIBUTE.ARTS]    = items["Arts"]
    self.Objs[_C.ATTRIBUTE.MUSIC]   = items["Music"]

end

function TrainItem:Init(train_flag)
    self.TrainFlag  = train_flag
    self.Name.text  = train_flag.Name

    self:FlushUI()
end

function TrainItem:FlushUI()
    local train_flag    = self.TrainFlag
    local attributes    = train_flag:GetAttributes()

    for k,v in pairs(attributes) do
        local obj       = self.Objs[k]

        if obj ~= nil then
            local des       = _C.NAME.ATTRIBUTE[k]
            if v >= 5 then
                des  = des ..  "  + +"
            elseif v > 0 then
                des  = des ..  "  +"
            elseif v == 0 then
                des  = des ..  "  ="
            else
                des  = des ..  "  -"
            end
    
            obj.text    = des 
        end
    end

    --价格
    local cost      = train_flag:GetCost()
    if Controller.Data.Account():GetMoney() < cost then
        self.Cost.text  = _C.COLOR.RED ..  string.format(_C.MESSAGE.FORMATEPRICE, SetShowNumber(cost)) .. "</color>"
    else
        self.Cost.text  = string.format(_C.MESSAGE.FORMATEPRICE, SetShowNumber(cost)) 
    end
end

function TrainItem:OnDestroy()

end


return TrainItem