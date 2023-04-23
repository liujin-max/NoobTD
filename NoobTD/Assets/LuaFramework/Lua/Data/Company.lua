--公司

local Company = Class.define("Data.Company")

function Company:GetStaffs()
    return self.Staffs
end

function Company:GetStaff(id)
    return self.StaffDic[id]    
end

function Company:GetName()
    return self.Name
end

function Company:GetMoney()
    return self.Money
end

function Company:GetMoneyText()
    return SetShowNumber(self:GetMoney(), true)
end

function Company:GetPositionCount()
    return self.Position
end

function Company:IsUnlock()
    return self.LockFlag == false
end

function Company:GetCost()
    return self.Cost
end

function Company:GetRent()
    return self.Rent
end

function Company:GetLevel()
    return self.Level
end

function Company:UpdateResearch(value)
    self.Research   = math.max(0, self.Research + value)
end

function Company:SyncMSG(msg)
    self.LockFlag   = false

    if msg.Name ~= nil then
        self.Name   = msg.Name
    end

    if msg.Money ~= nil then
        self.Money  = msg.Money
    end

    if msg.Research ~= nil then
        self.Research   = msg.Research
    end

    if msg.Staffs ~= nil then
        self.Staffs:Clear()
        self.StaffDic   = {}

        for _,cfg in ipairs(msg.Staffs) do
            local staff = Class.new(Data.Staff, Table.Get(Table.StaffTable, cfg.ID))
            staff:SyncMSG(cfg)
            
            self:AddStaff(staff)
        end
    end
end

function Company:ctor(config)
    self.Money      = 150000        --存款
    self.Research   = 0

    self.ID         = config.ID
    self.Name       = config.Name           --名字
    self.Level      = config.Level
    self.Position   = config.Position       --位子
    self.IsMy       = config.IsMy == 1      --是否是我的
    self.ResPath    = config.ResPath
    self.Cost       = config.Cost or 0      --搬迁费用
    self.Rent       = config.rent or 0      --房租
    self.MoveRes    = config.MoveRes or ""

    --员工们
    self.Staffs     = Class.new(Array)
    self.StaffDic   = {}

    self.LockFlag       = true
end

function Company:Display()
    self.Entity     = Class.new(Display.Company, self)
end

function Company:Dispose()
    if self.Entity ~= nil then
        self.Entity:Dispose()
    end
    self.Entity = nil
end

function Company:Unlock()
    self.LockFlag = false
end

function Company:SetName(name)
    self.Name       = name
end

function Company:UpdateMoney(value)
    self.Money  = round(self.Money + value)
end

function Company:Update(delta_time)
    -- self.Staffs:Each(function(staff)
    --     staff:Update(delta_time)
    -- end)
end

function Company:AddStaff(staff)
    self.Staffs:Add(staff)
    self.StaffDic[staff.ID] = staff
end

function Company:RemoveStaff(staff)
    self.Staffs:Remove(staff)    
    self.StaffDic[staff.ID] = nil
end

function Company:IsStaffFull()
    return self.Staffs:Count() >= self.Position
end

function Company:CopyFrom(company)
    self.Money      = company.Money
    self.Research   = company.Research
    self.Name       = company.Name

    local staffs    = company.Staffs
    for i = 1, staffs:Count() do
        local staff = staffs:Get(i)
        self.Staffs:Add(staff)
        self.StaffDic[staff.ID] = staff
    end
    company.Staffs:Clear()
    company.StaffDic= {}
end

function Company:GetSalarys()
    local staffs    = self:GetStaffs()

    local salary    = 0
    for i = 1, staffs:Count() do
        local stf   = staffs:Get(i)
        salary      = salary + stf:GetSalary()
    end
    return salary
end




--随机生成
function Company:NewRandomGame()

end



return Company