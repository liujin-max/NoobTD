local AttributeValue = Class.define("Data.AttributeValue")

function AttributeValue:ctor(baseValue, isInt)
    self._ORIGIN    = Crypt.E(baseValue)
    self._BASE      = Crypt.E(baseValue)

    self.ListADD    = {}
    self.ListAUL    = {}
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


function AttributeValue:PutAUL(buff, value)
    self.ListAUL[buff] = Crypt.E(value)
end

--乘法
function AttributeValue:PutMUL(buff, value)
    self.ListMUL[buff] = Crypt.E(value)
end

--清除buff
function AttributeValue:Pop(buff)
    self.ListADD[buff]  = nil
    self.ListAUL[buff]  = nil
    self.ListMUL[buff]  = nil
end

function AttributeValue:GetAdd(buff)
    return self.ListADD[buff]
end

function AttributeValue:BaseNumber()
    local add = Crypt.D(self._BASE)
    return add
end

function AttributeValue:Clear()
    self._BASE      = self._ORIGIN
    self.ListADD    = {}
    self.ListAUL    = {}
    self.ListMUL    = {}
end

function AttributeValue:ToNumber()
    local base  = self:BaseNumber()
    local add   = 0
    local aul   = 1
    local mul   = 1

    for k, b in pairs(self.ListADD) do
        add = add + Crypt.D(b)
    end

    for k, b in pairs(self.ListAUL) do
        aul = aul + Crypt.D(b)
    end

    for k, b in pairs(self.ListMUL) do
        mul = mul * Crypt.D(b)
    end

    return (base + add) * aul * mul
end

return AttributeValue
