--技能表现片段 基类

local ShowComp = Class.define("Display.ShowComp")

function ShowComp:ctor(data, skill, avatar)
    self.Data       = data
    self.Skill      = skill
    self.Avatar     = avatar
    self.Time       = data.time

    self.FinishFlag = false
    self.StartFlag  = false
end

function ShowComp:IsFinished()
    return self.FinishFlag
end

function ShowComp:Finish()
    self.FinishFlag = true
end

function ShowComp:IsStarted()
    return self.StartFlag
end

function ShowComp:Interrupt()
    
end

function ShowComp:Start()
    self.StartFlag = true
end

function ShowComp:Update(deltaTime)

end


return ShowComp