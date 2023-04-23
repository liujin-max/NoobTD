--游戏主机

local GameConsole = Class.define("Data.GameConsole")

function GameConsole:ExportTable(is_my)
    local console_table = {}

    if is_my == true then
        console_table   = 
        {
            ID          = self.ID,
            Name        = self.Name,
            Belong      = self.Belong,
            Cost        = self.Cost,
            OfferingDate= self.OfferingDate,
            IsUnlockTip = self.IsUnlockTip,
            IsExitTip   = self.IsExitTip,
            STATE       = self.STATE,
            BuildTimes  = self.BuildTimes,
            SalesDegree = self.SalesDegree,
            CPU         = self.CPU.ID,
            GPU         = self.GPU.ID,
            RAM         = self.RAM.ID
        }
        
        console_table.AttributeADD  = {}
        console_table.Attributes    = {}
        for k,v in pairs(self.Attributes) do
            table.insert(console_table.Attributes, {ID = k, Value = v})
        end

        for k,v in pairs(self.AttributeADD) do
            table.insert(console_table.AttributeADD, {ID = k, Value = v})
        end
    else
        console_table = 
        {
            ID          = self.ID,
            IsUnlockTip = self.IsUnlockTip,
            IsExitTip   = self.IsExitTip,
            STATE       = self.STATE,
            BuildTimes  = self.BuildTimes,
        }
    end

    return console_table
end

function GameConsole:SyncMSG(msg)
    if msg.Name ~= nil then
        self.Name       = msg.Name
    end

    if msg.Belong ~= nil then
        self.Belong     = msg.Belong
    end

    if msg.Cost ~= nil then
        self.Cost       = msg.Cost
    end

    if msg.SalesDegree ~= nil then
        self.SalesDegree    = msg.SalesDegree
    end

    if msg.OfferingDate ~= nil then
        self.OfferingDate   = msg.OfferingDate
    end

    if msg.IsUnlockTip ~= nil then
        self.IsUnlockTip    = msg.IsUnlockTip
    end   
    
    if msg.IsExitTip ~= nil then
        self.IsExitTip      = msg.IsExitTip
    end    

    if msg.STATE ~= nil then
        self:SetState(msg.STATE)
    end

    if msg.BuildTimes ~= nil then
        self.BuildTimes     = msg.BuildTimes
    end

    if msg.Attributes ~= nil then
        self.Attributes = {}
        for _,v in ipairs(msg.Attributes) do
            self.Attributes[v.ID] = v.Value
        end
    end

    if msg.AttributeADD ~= nil then
        self.AttributeADD = {}
        for _,v in ipairs(msg.AttributeADD) do
            self.AttributeADD[v.ID] = v.Value
        end
    end

    if msg.CPU ~= nil then
        self.CPU    = Controller.Data.Menu():GetCPU(msg.CPU)
    end

    if msg.GPU ~= nil then
        self.GPU    = Controller.Data.Menu():GetGPU(msg.GPU)
    end

    if msg.RAM ~= nil then
        self.RAM    = Controller.Data.Menu():GetRAM(msg.RAM)
    end
end

function GameConsole:ctor(config)
    self.ID         = config.ID     --序列
    self.Name       = config.Name
    self.Belong     = config.Belong         --company的id
    self.Description= config.Description
    self.Cost       = config.Cost
    self.People     = config.People or 0

    self.OfferingDate       = nil

    --主机属性
    self.Attributes = {}
    self.Attributes[_C.ATTRIBUTE.PLAN]      = config.Plan
    self.Attributes[_C.ATTRIBUTE.PROGRAM]   = config.Program
    self.Attributes[_C.ATTRIBUTE.ARTS]      = config.Arts
    self.Attributes[_C.ATTRIBUTE.MUSIC]     = config.Music

    --属性成长  
    self.AttributeADD                       = {}
    self.AttributeADD[_C.ATTRIBUTE.PLAN]    = 0
    self.AttributeADD[_C.ATTRIBUTE.PROGRAM] = 0
    self.AttributeADD[_C.ATTRIBUTE.ARTS]    = 0
    self.AttributeADD[_C.ATTRIBUTE.MUSIC]   = 0


    --解锁条件
    self.UnlockConditions   = config.unlock_condition ~= nil and ParseConditions(config.unlock_condition) or Class.new(Array)
    --退出市场条件
    self.ExitConditions     = config.exit_condition ~= nil and ParseConditions(config.exit_condition) or Class.new(Array)

    self.ShareRate      = Class.new(Data.Pair, 0 , 100)     --市场占有率


    self.STATE          = _C.GAMECONSOLE.STATE.LOCK
    self.IsUnlockTip    = false
    self.IsExitTip      = false
    self.BuildTimes     = 0

    --销售度(1-100)（根据能力值得出最高市场份额，然后根据销售度得出当前的市场份额）
    self.SalesDegree    = 100   --电脑产的主机，上来就是100，他们没有缓慢销售的过程
    --
end

function GameConsole:BuildFromHardware(hardware)
    self.IsOurBuild = true
    self.Belong     = Controller.Data.Account():GetCompany().ID
    self.Cost       = hardware.CPU:GetMakeCost() + hardware.GPU:GetMakeCost() + hardware.RAM:GetMakeCost()

    self.CPU        = hardware.CPU
    self.GPU        = hardware.GPU
    self.RAM        = hardware.RAM

    --继承属性
    for k,v in pairs(hardware.Attributes) do
        self.Attributes[k]  = v
    end
end

function GameConsole:IsOwn()
    return self.IsOurBuild == true
end

function GameConsole:GetSalesDegree()
    return self.SalesDegree
end

function GameConsole:SetSalesDegree(value)
    self.SalesDegree    = value
end


function GameConsole:SetName(text)
    self.Name   = text    
end

function GameConsole:SetOfferingDate(value)
    self.OfferingDate   = value
end

function GameConsole:GetState()
    return self.STATE
end

function GameConsole:SetState(_state)
    self.STATE  = _state    
end

function GameConsole:UpdateShareRate(value)
    self.ShareRate:SetCurrent(value)
end

function GameConsole:GetShareRate()
    return self.ShareRate:GetCurrent()
end

function GameConsole:GetCost()
    return self.Cost
end

function GameConsole:GetBuildTimes()
    return self.BuildTimes
end

function GameConsole:AddBuildTimes()
    self.BuildTimes = self.BuildTimes + 1
end

function GameConsole:GetAttribute(k)
    return self.Attributes[k]  + self.AttributeADD[k]
end

function GameConsole:AddAttribute(k, value)
    self.AttributeADD[k]    = self.AttributeADD[k] + value
    self.AttributeADD[k]    = math.min(self.AttributeADD[k], math.floor(self.Attributes[k] / 2))
end

function GameConsole:GetAttributeTotal()
    local count = 0
    for k,v in pairs(self.Attributes) do
        count   = count + v
    end
    for k,v in pairs(self.AttributeADD) do
        count   = count + v
    end

    return count
end

function GameConsole:CheckUnlock()
    for i = 1, self.UnlockConditions:Count() do
        local condition = self.UnlockConditions:Get(i)
        if condition:Check() == false then
            return false
        end
    end
    return true
end

function GameConsole:CheckExit()
    if self.ExitConditions:Count() == 0 then
        return false
    end

    for i = 1, self.ExitConditions:Count() do
        local condition = self.ExitConditions:Get(i)
        if condition:Check() == false then
            return false
        end
    end
    return true
end

function GameConsole:GetUnlockTime()
    if self.OfferingDate ~= nil then
        return self.OfferingDate
    end

    for i = 1, self.UnlockConditions:Count() do
        local condition = self.UnlockConditions:Get(i)
        if condition.ID == 100 then
            return condition.Value
        end
    end
    return nil
end

function GameConsole:GetExitTime()
    for i = 1, self.ExitConditions:Count() do
        local condition = self.ExitConditions:Get(i)
        if condition.ID == 100 then
            return condition.Value
        end
    end
    return nil
end


return GameConsole