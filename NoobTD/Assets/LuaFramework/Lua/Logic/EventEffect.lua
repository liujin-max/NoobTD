--事件效果器

local EventEffect = Class.define("Logic.EventEffect")

local EFFECT_LIST = {}

--建造塔
EFFECT_LIST[1000] =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self, params)
        local denfender = params.Defender

        if denfender == nil then
            return
        end

        Logic.Battle.BuildTower(self.Value, denfender)
    end,

    [_C.EVENT.TRIGGER.COST] = function(self)
        local config = Table.Get(Table.TowerTable, self.Value)
        return config.Cost
    end,

    [_C.EVENT.TRIGGER.DESCRIPTION] = function(self)
        local config = Table.Get(Table.TowerTable, self.Value)
        return config.Name
    end
}



EFFECT_LIST[9999] =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Controller.System.FlyTip("未实现的事件效果器： " .. self.ID)
    end
}



function EventEffect:ctor(id, value)
    self.ID         = id
    self.Value      = value
    self.Text       = Table.Get(Table.EventEffectListTable, self.ID)[2]


    self.Params     = {}



    self.Entity     = EFFECT_LIST [self.ID]
    if self.Entity == nil then
        self.Entity = EFFECT_LIST[9999999]
    end
    
end

function EventEffect:IsExecutable()
    if self.Entity[_C.EVENT.TRIGGER.EXECUTABLE] ~= nil then
        return self.Entity[_C.EVENT.TRIGGER.EXECUTABLE](self)
    end

    return true
end

function EventEffect:Execute(params)
    if self.Entity[_C.EVENT.TRIGGER.EXECUTE] ~= nil then
        self.Entity[_C.EVENT.TRIGGER.EXECUTE](self, params)
    end
    self.Executed   = true
end

function EventEffect:GetCost()
    if self.Entity[_C.EVENT.TRIGGER.COST] ~= nil then
        return self.Entity[_C.EVENT.TRIGGER.COST](self)
    end
    return 0
end

function EventEffect:Description()
    if self.Entity[_C.EVENT.TRIGGER.DESCRIPTION] ~= nil then
        return self.Entity[_C.EVENT.TRIGGER.DESCRIPTION](self)
    end
    return string.gsub(self.Text, "#", self.Value)
end


return EventEffect