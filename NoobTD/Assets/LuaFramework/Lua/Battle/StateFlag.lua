--orb状态
local StateFlag = Class.define("Battle.StateFlag")


function StateFlag:ctor()
    self.SubFlag        = false --分裂球
    self.SplitCount     = 0     --可分裂个数

    self.HitBubbles     = Class.new(Array)  --击中的bubble, 结构{AttrbuteType, Value}

    self.PointCount     = 2
end




return StateFlag