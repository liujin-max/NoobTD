--技能表现
--播放配置好的技能表现

local SkillShow = Class.define("Display.SkillShow")


local ASSUMPTION_MAX_TIME = 10 


local MATCH = {}

MATCH[_C.SKILL.SHOW.BULLET] = Display.BulletComp


function SkillShow:ctor(skill)
    self.Model      = skill

    self.Data       = Table.SkillShowTable.Get(skill.DisplayID)

    self.Timer      = Class.new(Logic.CDTimer, ASSUMPTION_MAX_TIME)
    self.Tasks      = Class.new(Array)

    --释放中
    self.CastFlag   = false
end

function SkillShow:IsCasting()
    return self.CastFlag
end

function SkillShow:Cast()
    self.CastFlag   = true
    self.Tasks:Clear()
    self.Timer:Reset()

    for i, d in ipairs(self.Data) do
        assert(MATCH[d.type], "MATCH is nil : " .. tostring(d.type))

        local comp = Class.new(MATCH[d.type], d, self.Model, self.Model.Owner.Avatar)
        self.Tasks:Add(comp)
    end
end

function SkillShow:Interrupt()
    self.CastFlag = false

    self.Tasks:Each(function(t)
        t:Interrupt()
    end)
    self.Tasks:Clear()
end

function SkillShow:Over()
    self.CastFlag = false


end

function SkillShow:Update(deltaTime)
    if self:IsCasting() == false then
        return
    end

    self.Timer:Update(deltaTime)

    self.Tasks:Each(function(comp)
        --如果时间到了, 就要开启
        if comp:IsStarted() == false then
            if self.Timer:GetCurrent() >= comp.Time then
                comp:Start()
            end
        else
            if comp:IsFinished() == false then
                comp:Update(deltaTime)
            end
        end
    end)
end


--技能播放是否结束
function SkillShow:IsOver()
    for i = self.Tasks:Count(), 1, -1 do
        local comp = self.Tasks:Get(i)
        if comp:IsFinished() == false then
            return false
        end
    end

    return true
end


return SkillShow