--

local HitComp = Class.define("Display.HitComp", Display.ShowComp)

function HitComp:ctor(data, skill, avatar)
    super(Display.HitComp, self, "ctor", data, skill, avatar)
end

function HitComp:Start()
    super(Display.HitComp, self, "Start")

    local targets = self.Skill.Targets

    targets:Each(function(target)
        if Logic.Battle.IsAvailable(target) == true then
            local hit = Class.new(Battle.Hit, _C.HIT.TYPE.ATK, self.Skill.Owner, target, self.Skill)
            Battle.FIELD:RegisterHit(hit)
        end
    end)

    self:Finish()
end

function HitComp:Update(deltaTime)

end


return HitComp