--职业

local Job = Class.define("Data.Job")


function Job:GetAttribute(attribute_type)
    return self.Attributes[attribute_type]
end

function Job:GetNexts()
    return self.Nexts
end

function Job:IsMax()
    return #self.Nexts == 0
end

function Job:GetType()
    return self.Type
end

function Job:GetResearchCost()
    return self.ResearchCost
end

function Job:GetSalary()
    return self.Salary
end

function Job:GetSpeed()
    return self.Speed
end

function Job:ctor(config)
    self.ID         = config.ID
    self.Name       = config.Name
    self.Type       = config.Type
    self.Descript   = config.Description or ""
    self.Salary     = config.Salary             --年薪
    self.Speed      = config.Speed

    self.Level      = config.Level
    self.Grade      = config.Grade

    self.ResearchCost   = config.ResearchCost   --研究点消耗

    --属性
    self.Attributes = {}
    self.Attributes[_C.ATTRIBUTE.PLAN]      = config.Plan
    self.Attributes[_C.ATTRIBUTE.PROGRAM]   = config.Program
    self.Attributes[_C.ATTRIBUTE.ARTS]      = config.Arts
    self.Attributes[_C.ATTRIBUTE.MUSIC]     = config.Music

    self.Nexts      = config.Nexts
end

function Job:Description()
    return self.Descript
end



return Job