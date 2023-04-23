local Effect = Class.define("Logic.Effect")

local EFFECT_LIST = {}


function Effect:ctor(id, value)
    self.ID         = id
    self.Value      = Class.new(Data.AttributeValue,    value)
    self.Text       = Table.Get(Table.EffectListTable, self.ID)[2]

    self.Entity     = EFFECT_LIST [self.ID]
    assert(self.Entity, "EFFECT_LIST is nil : " .. tostring(self.ID))
    

    self.Params     = {}
end

function Effect:Trigger(phase, params)
    if self.Entity[phase] ~= nil then
        self.Entity[phase](self, params)
    end
end




function Effect:Description()
    if self.Entity[_C.PHASE.DESCRIPTION] ~= nil then
        return self.Entity[_C.PHASE.DESCRIPTION](self)
    end
    return string.gsub(self.Text, "#", self.Value:ToNumber())
end


return Effect