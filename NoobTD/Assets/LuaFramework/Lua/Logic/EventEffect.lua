--事件效果器
--用于防守位的建造、升级、技能升级等

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

        Battle.FIELD.Handler:Build(self.Value, denfender)
    end,

    [_C.EVENT.TRIGGER.PRELOAD] = function(self, params)
        local denfender = params.Defender

        if denfender == nil then
            return
        end

        Battle.FIELD.Handler:Preload(self.Value, denfender)
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

--升级塔
EFFECT_LIST[1001] =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self, params)
        local denfender = params.Defender

        if denfender == nil then
            return
        end

        local tower = denfender:GetTower()

        if tower == nil then
            return
        end

        Battle.FIELD.Handler:Upgrade(tower, self.Value)
    end,

    [_C.EVENT.TRIGGER.PRELOAD] = function(self, params)
        local denfender = params.Defender

        if denfender == nil then
            return
        end

        Battle.FIELD.Handler:ShowRange(true, self.Value, denfender:CenterPos())
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


--学习技能
--将Class#技能提升至下一级（未学习则学习，已学习则将当前等级提升至下一级）
EFFECT_LIST[1002] =
{
    GET_SKILL   = function(self)
        
    end,

    [_C.EVENT.TRIGGER.EXECUTE] = function(self, params)

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



function EventEffect:ctor(id, value)
    self.ID         = id
    self.Value      = value
    self.Text       = Table.Get(Table.EventEffectListTable, self.ID)[2]


    self.Params     = {}


    self.Entity     = EFFECT_LIST [self.ID] or {}

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
end

function EventEffect:GetCost()
    if self.Entity[_C.EVENT.TRIGGER.COST] ~= nil then
        return self.Entity[_C.EVENT.TRIGGER.COST](self)
    end
    return 0
end


function EventEffect:Preload(params)
    if self.Entity[_C.EVENT.TRIGGER.PRELOAD] ~= nil then
        self.Entity[_C.EVENT.TRIGGER.PRELOAD](self, params)
    end
end

function EventEffect:Description()
    if self.Entity[_C.EVENT.TRIGGER.DESCRIPTION] ~= nil then
        return self.Entity[_C.EVENT.TRIGGER.DESCRIPTION](self)
    end
    return string.gsub(self.Text, "#", self.Value)
end


return EventEffect