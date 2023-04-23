
local Trace = Class.define("Battle.Trace")


function Trace:ctor(entity)
    self.Entity     = entity

    self.Actived    = false
    self.Arrived    = false
end

function Trace:IsArrived()
    return self.Arrived
end

function Trace:Go()
    self.Actived    = true
end

function Trace:Update(delta_time)

end



return Trace