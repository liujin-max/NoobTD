--战场格子
--格子分多种
-- => 路线
-- => 防守位
-- => 地形
-- => 等等....

--尺寸 50 * 50


local Grid = Class.define("Battle.Grid")


function Grid:ctor(land, pos_cfg)
    self.Land   = land

    self.Pos    = Vector3.New(pos_cfg[1], pos_cfg[2], pos_cfg[3])
end

function Grid:CenterPos()
    return self.Pos
end

function Grid:Display(parent)

end


function Grid:Update(deltatime)
    
end



return Grid