--战场单位

local Unit = Class.define("Battle.Unit")

local function ParseSkill(self)
    self.Skills     = Class.new(Array)
    self.SkillDic   = {}

    for i, id in ipairs(self.Table.Skills) do
        local skill = Class.new(Battle.Skill, Table.Get(Table.SkillTable, id), self)
        self.Skills:Add(skill)
        self.SkillDic[id] = skill
    end
end

function Unit:ctor(cfg, side)
    self:ReBuild(cfg)

    self.Side       = side

    self.StateFlag  = Class.new(Battle.StateFlag, self)
    self.Behaviour  = nil

    self.Avatar     = Class.new(Display.Avatar, self)
end

function Unit:ReBuild(cfg)
    self.Table      = cfg
    self.ID         = cfg.ID
    self.Name       = cfg.Name
    self.Character  = cfg.Character

    --@region 属性
    self.HP         = Class.new(Data.Pair, cfg.HP, cfg.HP)
    self.ARMOR      = Class.new(Data.Pair, 0, 0)
    self.ATK        = Class.new(Data.AttributeValue, cfg.Atk)
    self.SPEED      = Class.new(Data.AttributeValue, cfg.Speed / 100.0)
    --@endregion


    self.Buffs      = {}

    ParseSkill(self)
    
end

function Unit:InitBehaviour()

end

function Unit:GetSPEED()
    return self.SPEED:ToNumber()
end

function Unit:GetATK()
    return self.ATK:ToNumber()
end

function Unit:GetARMOR()
    return self.ARMOR:GetCurrent()
end

function Unit:UpdateARMOR(value)
    self.ARMOR._Current = math.max(0, self.ARMOR._Current + value)
    self.ARMOR._Current = math.min(self.ARMOR._Total, self.ARMOR._Current)

    self.Avatar:FlushARMOR(self.ARMOR._Current, self.ARMOR._Total)
end

function Unit:GetHP()
    return self.HP:GetCurrent()
end

function Unit:GetHPMax()
    return self.HP:GetTotal()
end

function Unit:UpdateHP(value)
    self.HP._Current    = math.max(0, self.HP._Current + value)
    self.HP._Current    = math.min(self.HP._Total, self.HP._Current)

    self.Avatar:FlushHP(self.HP._Current, self.HP._Total)
end

function Unit:IsDead() 
    return self.StateFlag._IsDead
end

function Unit:Dead() 
    self.StateFlag._IsDead  = true
end

function Unit:IsGC()
    return self.StateFlag._IsGC == true
end

--正在释放技能
function Unit:IsCasting()
    return self:GetCastingSkill() ~= nil
end

--获得正在释放的技能
function Unit:GetCastingSkill()
    for i = 1, self.Skills:Count() do
        local sk = self.Skills:Get(i)
        if sk:IsCasting() == true then
            return sk
        end
    end
end

--可以释放的技能
function Unit:GetPlayableSkills()
    local temp = Class.new(Array)

    self.Skills:Each(function(sk)
        if sk:IsReady() == true then
            temp:Add(sk)
        end      
    end)

    return temp
end

function Unit:Update(deltatime)
    if self.Behaviour ~= nil then
        self.Behaviour:Update(deltatime)
    end

    self.Skills:Each(function(sk)
        sk:Update(deltatime)        
    end)

    --
    self.Avatar:Update(deltatime)
end

-------------------- buff --------------------
function Unit:AddBuff(id, caster)
    
end

function Unit:RemoveBuff(id)
    
end

function Unit:CleanBuff()
    for id, buff in pairs(self.Buffs) do
        self:RemoveBuff(id)
    end
    self.Buffs = {}
end
----------------------------------------------

function Unit:Dispose()
    self.Behaviour  = nil

    self.Avatar:Dispose()
end

return Unit