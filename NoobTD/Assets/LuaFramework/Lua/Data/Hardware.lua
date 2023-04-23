--制造中的主机

local Hardware = Class.define("Data.Hardware")

function Hardware:ExportTable()
    local hardware  = {}

    hardware.ID         = self.ID
    hardware.Name       = self.Name
    hardware.CPU        = self.CPU.ID
    hardware.GPU        = self.GPU.ID 
    hardware.RAM        = self.RAM.ID
    hardware.Process    = self.Process
    hardware.Progress   = {Value = self.Progress:GetCurrent() , Total = self.Progress:GetTotal()}

    hardware.Attributes   = {}
    for k,v in pairs(self.Attributes) do
        table.insert(hardware.Attributes, {ID = k, Value = v})
    end


    return hardware
end

function Hardware:SyncMSG(msg)
    if msg.ID ~= nil then
        self.ID         = msg.ID
    end

    if msg.Name ~= nil then
        self.Name       = msg.Name
    end

    if msg.Process ~= nil then
        self.Process    = msg.Process
    end

    if msg.Progress ~= nil then
        self.Progress:Set(msg.Progress.Value, msg.Progress.Total)
    end

    if msg.Attributes ~= nil then
        self.Attributes = {}
        for _,v in ipairs(msg.Attributes) do
            self.Attributes[v.ID] = v.Value
        end
    end
end

function Hardware:ctor(order, name , cpu, gpu, ram)
    self.ID             = order --序列
    self.Name           = name
    self.CPU            = cpu
    self.GPU            = gpu
    self.RAM            = ram

    self.Process        = nil   --开发阶段
    self.Progress       = Class.new(Logic.CDTimer,  1)

    --4项属性
    self.Attributes     = {}
    self.Attributes[_C.ATTRIBUTE.PLAN]      = 0
    self.Attributes[_C.ATTRIBUTE.PROGRAM]   = 0
    self.Attributes[_C.ATTRIBUTE.ARTS]      = 0
    self.Attributes[_C.ATTRIBUTE.MUSIC]     = 0
end

function Hardware:SetProcess(process)
    self.Process    = process
end

function Hardware:GetProcess()
    return self.Process
end

function Hardware:GetProgress()
    return self.Progress:GetProgress()
end

function Hardware:AddAttribute(attribute_type, value)
    self.Attributes[attribute_type] = self.Attributes[attribute_type] + value
end

function Hardware:GetAttributeShow()
    local array     = Class.new(Array)

    for k,v in pairs(self.Attributes) do
        array:Add({Type = k, Value = v})
    end
    array:SortBy("Type", false)
    return array
end

function Hardware:GetSpeed()
    return self.CPU:GetSpeed() + self.GPU:GetSpeed() + self.RAM:GetSpeed()
end


function Hardware:Update(delta_time)
    self.Progress:Update(delta_time)    
end



return Hardware