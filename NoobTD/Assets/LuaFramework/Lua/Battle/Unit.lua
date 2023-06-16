--战场单位

local Unit = Class.define("Battle.Unit")


--技能结构
--每个单位有N个SkillClass，每个SkillClass代表一系技能，里面包含N个技能，每个技能的Class是相同的
--技能可以升级，每个SkillClass当前可执行的技能，取决于SkillClass的等级
--升级技能，即为提升SkillClass的等级
local function ParseSkill(self)
    self.SkillClass = Class.new(Array)

    for i, id in ipairs(self.Table.SkillClass) do
        local class = Class.new(Battle.SkillClass, Table.Get(Table.SkillClassTable, id), self)
        self.SkillClass:Add(class)
    end
end

function Unit:ctor(cfg, side)
    self:ReBuild(cfg)

    self.Side       = side
    self.Face       = _C.AVATAR.FACE.RIGHT  --默认朝右

    self.StateFlag  = Class.new(Battle.StateFlag, self)
    self.Behaviour  = nil

    self.Avatar     = Class.new(Display.Avatar, self)

    self.Pos        = Vector3.zero  --坐标
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

    --受到的伤害减免或者加成比例
    self.DEFRATE    = Class.new(Data.AttributeValue, 1)
    --@endregion


    self.Buffs      = {}
    self.BuffEntitys= {}

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

function Unit:FaceTo(face)    
    self.Face   = face

    self.Avatar:Face()
end

function Unit:GetFace()
    return self.Face
end

function Unit:SetPos(pos)
    self.Pos    = pos
    
    self.Avatar:SetPosition(pos)
end

function Unit:GetPos()
    return self.Pos 
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

--创建完成时调用
function Unit:Ready()
    self.SkillClass:Each(function(class)
        class:ResetCD()
    end)
end

--
function Unit:GetDefaultSkill()
    return self.SkillClass:First():GetSkill()
end

--普攻的攻击范围
function Unit:GetAtkRange()
    local skill = self:GetDefaultSkill()

    if skill == nil then
        return 0
    end

    return skill:GetRange()
end

--正在释放技能
function Unit:IsCasting()
    return self:GetCastingSkill() ~= nil
end

--获得正在释放的技能
function Unit:GetCastingSkill()
    for i = 1, self.SkillClass:Count() do
        local class = self.SkillClass:Get(i)
        if class:IsCasting() == true then
            return class:GetSkill()
        end
    end
end

--可以释放的技能
function Unit:GetPlayableSkills()
    local temp = Class.new(Array)

    self.SkillClass:Each(function(class)
        if class:IsReady() == true then
            temp:Add(class:GetSkill())
        end      
    end)

    return temp
end

function Unit:Update(deltatime)
    if self.Behaviour ~= nil then
        self.Behaviour:Update(deltatime)
    end


    self.Avatar:Update(deltatime)

    if self:IsDead() == true then
        return
    end

    for id, buff in pairs(self.Buffs) do
        buff:Update(deltatime)
    end

    self.SkillClass:Each(function(class)
        class:Update(deltatime)        
    end)

end

-------------------- buff --------------------
function Unit:AddBuff(id, caster)
    if self:IsDead() == true then return end

    local buff_table    = Table.Get(Table.BuffTable, id)
    assert(buff_table, "BuffTable is nil : " .. tostring(id))


    --覆盖 已经有相同EntityID的buff存在时 就移除，然后添加新的
    --叠加 就叠加咯
    --唯一 已经有相同EntityID的buff存在时 就无视
    if buff_table.Extend == _C.BUFF.EXTEND.ADD then  --叠加型
        if self.BuffEntitys[buff_table.EntityID] == nil then
            self.BuffEntitys[buff_table.EntityID]  = {}
        end

        if self.BuffEntitys[buff_table.EntityID][id] == nil then
            local buff      = Class.new(Battle.Buff, id, self, caster)
            self.Buffs[id] = buff
            self.BuffEntitys[buff_table.EntityID][id] = buff

            buff:Prepare()
        else
            self.BuffEntitys[buff_table.EntityID][id]:AddCount(caster)
            self.BuffEntitys[buff_table.EntityID][id]:Flush()
        end

    elseif buff_table.Extend == _C.BUFF.EXTEND.ONLY   then    --唯一
        if self.BuffEntitys[buff_table.EntityID] == nil then
            self.BuffEntitys[buff_table.EntityID]  = {}
        end

        if PairCount(self.BuffEntitys[buff_table.EntityID]) == 0 then
            local buff      = Class.new(Battle.Buff, id, self, caster)
            self.Buffs[id] = buff
            self.BuffEntitys[buff_table.EntityID][id] = buff

            buff:Prepare()
        end

    else    --覆盖
        if self.BuffEntitys[buff_table.EntityID] ~= nil then
            for buff_id, buff in pairs(self.BuffEntitys[buff_table.EntityID]) do
                self:RemoveBuff(buff_id)
            end
        end

        self.BuffEntitys[buff_table.EntityID]  = {}

        local buff      = Class.new(Battle.Buff, id, self, caster)
        self.Buffs[id] = buff
        self.BuffEntitys[buff_table.EntityID][id] = buff
        buff:Prepare()
    end

end

function Unit:RemoveBuff(id)
    local buff = self.Buffs[id]

    if buff == nil then
        return
    end

    buff:Dispose()

    if buff.Extend == _C.BUFF.EXTEND.ADD then    --叠加型
        self.BuffEntitys[buff.EntityID][id] = nil
    else
        self.BuffEntitys[buff.EntityID] = nil
    end

    self.Buffs[id] = nil 
end

function Unit:HasBuffByEntityID(entity_id)
    if self.BuffEntitys[entity_id] == nil then
        return false
    end

    if PairCount(self.BuffEntitys[entity_id]) == 0 then
        return false
    end

    return true
end

function Unit:CleanBuff()
    for id, buff in pairs(self.Buffs) do
        self:RemoveBuff(id)
    end
    self.Buffs = {}
    self.BuffEntitys   = {}
end
----------------------------------------------

function Unit:Dispose()
    self.Behaviour  = nil

    self.Avatar:Dispose()
end

return Unit