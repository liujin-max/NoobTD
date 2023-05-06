--子弹表现

local BulletComp = Class.define("Display.BulletComp", Display.ShowComp)

function BulletComp:ctor(data, skill, avatar)
    super(Display.BulletComp, self, "ctor", data, skill, avatar)
end

function BulletComp:Start()
    super(Display.BulletComp, self, "Start")

    local targets = self.Skill.Targets

    targets:Each(function(target)
        if Logic.Battle.IsAvailable(target) == true then
            local bullet = Class.new(Display.Bullet, self.Data.id, Class.new(Battle.Hit, _C.HIT.TYPE.ATK, self.Skill.Owner, target, self.Skill))
            bullet:Activate()

            Battle.FIELD:RegisterBullet(bullet)
        end
    end)

    self:Finish()
end

function BulletComp:Update(deltaTime)

end


return BulletComp