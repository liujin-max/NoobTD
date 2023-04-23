--外包

local Outsource = Class.define("Data.Outsource")

function Outsource:Export()
    local outsource_table       = {}
    outsource_table.ID          = self.ID
    outsource_table.CDTimer     = {Value = self.CDTimer:GetCurrent(), Total = self.CDTimer:GetTotal()}
    outsource_table.Reward      = self.Reward
    outsource_table.Coin        = self.Coin

    outsource_table.Attributes  = {}
    for k, pair in pairs(self.Attributes) do
        table.insert(outsource_table.Attributes, {ID = k, Value = pair:GetCurrent()})
    end


    return outsource_table
end

function Outsource:SyncMSG(msg)
    if msg.CDTimer ~= nil then
        self.CDTimer:Set(msg.CDTimer.Value, msg.CDTimer.Total)
    end

    if msg.Reward ~= nil then
        self.Reward = msg.Reward
    end

    if msg.Coin ~= nil then
        self.Coin   = msg.Coin
    end

    if msg.Attributes ~= nil then
        for _, cfg in ipairs(msg.Attributes) do
            local pair  = self:GetAttribute(cfg.ID)
            pair:UpdateCurrent(cfg.Value)
        end
    end
end

function Outsource:ctor(config)
    self.Table      = config
    self.ID         = config.ID
    self.Name       = config.Name
    self.Level      = config.Level

    self.Config     = config
    self.Reward     = Utility.Random.Range(config.Reward[1], config.Reward[2])
    self.Coin       = config.Coin

    self.CDTimer    = Class.new(Logic.CDTimer, 0)

    self.Attributes = {}
    self.Attributes[_C.ATTRIBUTE.PLAN]      = Class.new(Data.Pair, 0 , config.Plan)
    self.Attributes[_C.ATTRIBUTE.PROGRAM]   = Class.new(Data.Pair, 0 , config.Program)
    self.Attributes[_C.ATTRIBUTE.ARTS]      = Class.new(Data.Pair, 0 , config.Arts)
    self.Attributes[_C.ATTRIBUTE.MUSIC]     = Class.new(Data.Pair, 0 , config.Music)


end

function Outsource:Reset()
    self.Reward     = Utility.Random.Range(self.Config.Reward[1], self.Config.Reward[2])
    self.Coin       = self.Table.Coin + Utility.Random.Range(-1, 2) * 500

    local time      = Utility.Random.Range(self.Table.Time[1], self.Table.Time[2])
    self.CDTimer:Reset(time * _C.CONST.WEEKSECOND)

    for _, pair in pairs(self.Attributes) do
        pair:Clear()
    end 
end

function Outsource:GetTime()
    return self.CDTimer:GetTotal()
end

function Outsource:GetReward()
    return self.Reward
end

function Outsource:GetCoin()
    return self.Coin
end

function Outsource:GetAttribute(attributute_type)
    return self.Attributes[attributute_type]
end

function Outsource:AddAttribute(attribute_type, value)
    if self:IsAttributeFull(attribute_type) == true then
        return
    end

    self.Attributes[attribute_type]:UpdateCurrent(value)

    LuaEventManager.SendEvent(_E.OUTSOURCE_ADDATTRIBUTE, nil, attribute_type, value)
end

function Outsource:IsAttributeFull(attribute_type)
    local pair = self.Attributes[attribute_type]
    return pair:Full()
end

function Outsource:IsFinished()
    for type, _ in pairs(self.Attributes) do
        if self:IsAttributeFull(type) == false then
            return false
        end
    end
    return true
end

function Outsource:GetSurplusAttributes()
    local temp  = {}
    for attribute_type, _ in pairs(self.Attributes) do
        if self:IsAttributeFull(attribute_type) == false then
            table.insert(temp, attribute_type)
        end
    end

    return temp
end

return Outsource