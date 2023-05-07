--Buff
--区分逻辑id和表现id
--


local Buff = Class.define("Battle.Buff")

local ENUM  = {}


--减速
ENUM[1000] = 
{
    PREPARE = function(self)
        -- self.Show:Equip()

        self.Owner.SPEED:PutAUL(self, -self.Values[1] / 1000.0)

    end,

    UPDATE = function(self, deltaTime)
        self.Timer:Update(deltaTime)
        if self.Timer:IsFinished() == true then
            self.Owner:RemoveBuff(self.ID)
        end

    end,

    DISPOSE = function(self)
        -- self.Show:Dispose()

        self.Owner.SPEED:Pop(self)
    end
}

--标记
--受到的伤害提高#%
ENUM[1010] = 
{
    PREPARE = function(self)
        -- self.Show:Equip()

        self.Owner.DEFRATE:PutAUL(self, self.Values[1] / 1000.0)

    end,

    UPDATE = function(self, deltaTime)
        self.Timer:Update(deltaTime)
        if self.Timer:IsFinished() == true then
            self.Owner:RemoveBuff(self.ID)
        end

    end,

    DISPOSE = function(self)

        self.Owner.DEFRATE:Pop(self)
    end
}

ENUM[9999]  =
{

}

function Buff:ctor(id, owner, caster)
    self.Owner      = owner
    self.Caster     = caster

    self.Table      = Table.Get(Table.BuffTable, id)
    self.ID         = id


    self.Timer      = Class.new(Logic.CDTimer, self.Table.Time)

    self.EntityID   = self.Table.EntityID

    self.ENTITY     = ENUM[self.EntityID] or ENUM[9999]

    self.Values     = {}
    self.Values[1]  = self.Table.Value1

    self.Count      = 1     --层数
end

function Buff:AddCount()
    
end

function Buff:Prepare()
    if self.ENTITY.PREPARE ~= nil then
        self.ENTITY.PREPARE(self)
    end
end

function Buff:Dispose()
    if self.ENTITY.DISPOSE ~= nil then
        self.ENTITY.DISPOSE(self)
    end
end

function Buff:Update(deltatime)
    if self.ENTITY.UPDATE ~= nil then
        self.ENTITY.UPDATE(self, deltatime)
    end
end



return Buff