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

    self.Pos    = Vector3.New(pos_cfg[1] or 0, pos_cfg[2] or 0, 0)
end

function Grid:CenterPos()
    return self.Pos
end

function Grid:Decorate()

end


function Grid:Update(deltatime)
    
end



return Grid