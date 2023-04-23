
local StraightTrace = Class.define("Battle.StraightTrace", Battle.Trace)


function StraightTrace:ctor(entity, start_pos, to_pos, speed)
    super(Battle.StraightTrace, self, "ctor", entity)

    self.Pos    = start_pos
    self.ToPos  = to_pos

    self.Speed  = speed
end

function StraightTrace:Go()
    super(Battle.StraightTrace, self, "Go")

    self.Entity.transform.localPosition = self.Pos
end


function StraightTrace:Update(delta_time)
    if self.Actived == false or self.Arrived == true then return end

    local dir   = Vector3.Normalize(self.ToPos - self.Pos)
    local move  = dir * self.Speed * delta_time

    self.Pos    = self.Pos + move

    if Vector2.Distance(self.ToPos, self.Pos) <= 0.2 then
        self.Pos    = self.ToPos
        self.Arrived= true
    end

    self.Entity.transform.localPosition = self.Pos
end



return StraightTrace