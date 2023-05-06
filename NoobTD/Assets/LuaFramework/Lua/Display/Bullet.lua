--子弹, 有目标

local Bullet = Class.define("Display.Bullet")

function Bullet:ctor(bullet_id, hit)
    self.Data       = Table.BulletTable.GetData(bullet_id)
    self.ID         = bullet_id
    self.Hit        = hit
end

function Bullet:Activate()
    local pos       = self.Hit.Caster.Avatar:GetPivotPos(_C.AVATAR.PIVOT.ATK)
    local to        = self.Hit.Target.Avatar:GetPivotPos(_C.AVATAR.PIVOT.BODY)
    self.Effect     = Display.EffectManager.Add(self.Data.effect, pos)

    if self.Data.trace == _C.TRACE.PARABOLA then
        self.Trace  = Class.new(Display.ParabolaTrace, self.Effect, self.Data.rotate, self.Data.speed, pos, to, self.Data.height)
    else
        self.Trace  = Class.new(Display.PointTrace, self.Effect, self.Data.rotate ,self.Data.speed, pos, to)
    end

    self.Trace:GO() 
end

function Bullet:Update(deltaTime)
    if Logic.Battle.IsAvailable(self.Hit.Target) == true then
        self.Trace:SetEndPos(self.Hit.Target.Avatar:GetPivotPos(_C.AVATAR.PIVOT.BODY))
    end

    self.Trace:Update(deltaTime)

    if self.Trace:Arrived() == true then
        if Logic.Battle.IsAvailable(self.Hit.Target) == true then
            Battle.FIELD:RegisterHit(self.Hit)

            -- if self.Data.hit ~= nil then
            --     Display.EffectManager.AddTo(self.Data.hit, "Body", self.Target, nil, self.Data.reset_angles)
            -- end
        end

        self:Dispose()
    end
end

function Bullet:Dispose()
    Battle.FIELD:UnRegisterBullet(self)

    Display.EffectManager.Remove(self.Effect)
end

return Bullet