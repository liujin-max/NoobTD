
local RoundTrace = Class.define("Battle.RoundTrace", Battle.Trace)


--speed是每秒走过的角度
function RoundTrace:ctor(entity, center_pos, radius, speed )
    super(Battle.RoundTrace, self, "ctor", entity)

    self.CenterPos  = center_pos
    self.Radius     = radius
    self.Speed      = speed

    self.Angles     = 0
end

function RoundTrace:Go()
    super(Battle.RoundTrace, self, "Go")

    self.Entity.transform.localPosition = angle_radius_point(self.CenterPos, self.Angles, self.Radius)
end


function RoundTrace:Update(delta_time)
    if self.Actived == false or self.Arrived == true then return end

    
    self.Angles = self.Angles + self.Speed * delta_time
    if self.Angles >= 360 then
        self.Angles = self.Angles - 360
    end

    self.Entity.transform.localPosition = angle_radius_point(self.CenterPos, self.Angles, self.Radius)
end



return RoundTrace