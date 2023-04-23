--EventCondition: 事件的条件
local EventCondition = Class.define("Logic.EventCondition")

local ENUM = {}


ENUM[9999] = 
{
    [_C.EVENT.TRIGGER.CHECK] = function(self, params)
        return false
    end
}

function EventCondition:ctor(conditionID, value)
    self.ID     = conditionID
    self.Value  = value
    self.Text   = Table.Get(Table.EventConditionListTable, conditionID)[2]

    self.Entity = ENUM[self.ID]
    if self.Entity == nil then
        self.Entity = ENUM[9999]
    end

end


function EventCondition:Check(params)
    return self.Entity[_C.EVENT.TRIGGER.CHECK](self, params)
end

function EventCondition:Execute(params)
    return self.Entity[_C.EVENT.TRIGGER.EXECUTE](self, params)
end

function EventCondition:Description()
    if self.Entity[_C.EVENT.TRIGGER.DESCRIPTION] ~= nil then
        return self.Entity[_C.EVENT.TRIGGER.DESCRIPTION](self)
    end
    return string.gsub(self.Text, "#", self.Value)
end


return EventCondition