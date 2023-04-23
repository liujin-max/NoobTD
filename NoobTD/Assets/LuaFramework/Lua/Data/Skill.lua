
--技能

local Skill = Class.define("Data.Skill")


local function ParseSkillEffects(self)
    local level_cof     = self.Coefficients[1] / 1000.0 * self.Staff.Job.Grade
    local break_cof     = self.Coefficients[2] / 1000.0 * (self.Staff.Job.Level - 1)

    local final_cof     = math.floor(level_cof + break_cof)

    local effs          = Crypt.DV(clone(self.Config.Effect))
    local array         = Class.new(Array)
    for _, data in ipairs(effs) do
        local eff   = Class.new(Logic.Effect, data.id, data.value + final_cof)
        array:Add(eff)
    end
    return array
end

function Skill:Export()
    local sk_table  = 
    {
        ID          = self.ID
    }


    return sk_table
end

function Skill:Priority()
    return self.Staff.Job.Level * 100 + self.Staff.Job.Grade
end

function Skill:ctor(config, staff)
    self.Staff          = staff
    self.Config         = config
    self.ID             = config.ID
    self.Name           = config.Name
    self.Type           = config.Type
    self.Level          = config.Level

    self.Coefficients   = config.coefficients
    
    self.Effects        = ParseSkillEffects(self)
end

function Skill:Flush()
    self:UnEquip()
    self.Effects    = ParseSkillEffects(self)
    self:Equip()
end

function Skill:Equip()
    self.Effects:Each(function(eff)
        eff:Trigger(_C.PHASE.ONSKEQUIP,     {Skill = self})
    end)
end

function Skill:UnEquip()
    self.Effects:Each(function(eff)
        eff:Trigger(_C.PHASE.ONSKUNEQUIP,   {Skill = self})
    end)
end


function Skill:Description()
    local des   = ""
    for i = 1, self.Effects:Count() do
        local e = self.Effects:Get(i)
        des     = des .. e:Description()
    end
    return des
end


return Skill