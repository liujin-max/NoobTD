--子弹, 有目标

local Bullet = Class.define("Display.Bullet")

function Bullet:ctor(bullet_id, hit)
    self.Data       = Table.BulletTable.GetData(bullet_id)
    self.ID         = bullet_id
    self.Hit        = hit
end

function Bullet:Activate()
    local pos       = self.Hit.Caster.Avatar:GetPosition()
    local to        = self.Hit.Target.Avatar:GetPosition()
    self.Effect     = Display.EffectManager.Add(self.Data.effect, pos)

    self.Trace      = Class.new(Display.Trace, self.Effect, pos, to, self.Data.speed)
    self.Trace:GO()
end

function Bullet:Update(deltaTime)
    if Logic.Battle.IsAvailable(self.Hit.Target) == true then
        self.Trace:SetToPos(self.Hit.Target.Avatar:GetPosition())
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