local AttributeValue = Class.define("Data.AttributeValue")

function AttributeValue:ctor(baseValue, isInt)
    self._ORIGIN    = Crypt.E(baseValue)
    self._BASE      = Crypt.E(baseValue)
    self.ListADD    = {}
    self.ListMUL    = {}
end

function AttributeValue:GetBase()
    return Crypt.D(self._BASE)
end

function AttributeValue:SetBase(v)
    self._BASE = Crypt.E(v)
end

--加法
function AttributeValue:PutADD(buff, value)
    self.ListADD[buff] = Crypt.E(value)
end

--乘法
function AttributeValue:PutMUL(buff, value)
    self.ListMUL[buff] = Crypt.E(value)
end

--清除buff
function AttributeValue:Pop(buff)
    self.ListADD[buff] = nil
    self.ListMUL[buff] = nil
end

function AttributeValue:GetAdd(buff)
    return self.ListADD[buff]
end

function AttributeValue:PopByID(buffID)
    for k, b in pairs(self.ListADD) do
        if k.ID == buffID then
            self.ListADD[k] = nil
        end
    end

    for k, b in pairs(self.ListMUL) do
        if k.ID == buffID then
            self.ListMUL[k] = nil
        end
    end
end

function AttributeValue:BaseNumber()
    local add = Crypt.D(self._BASE)
    return add
end

function AttributeValue:Clear()
    self._BASE      = self._ORIGIN
    self.ListADD    = {}
    self.ListMUL    = {}
end

function AttributeValue:ToNumber()
    local base = self:BaseNumber()
    local add  = 0
    local mul  = 1
    local base_mul = 1
    for k, b in pairs(self.ListADD) do
        add = add + Crypt.D(b)
    end

    for k, b in pairs(self.ListMUL) do
        mul = mul * Crypt.D(b)
    end

    return (base * base_mul + add) * mul
end

return AttributeValue
