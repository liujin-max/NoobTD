--战场格子
--格子分多种
-- => 路线
-- => 防守位
-- => 地形
-- => 等等....

--尺寸 50 * 50


local Grid = Class.define("Battle.Grid")

function Grid.GetPos(x, y)
    local pos_x     = -_C.CONST.LAND.WIDTH / 2 + _C.CONST.LAND.GRID / 200 + x * _C.CONST.LAND.GRID / 100
    local pos_y     = -_C.CONST.LAND.HEIGHT / 2 + _C.CONST.LAND.GRID / 200 + y * _C.CONST.LAND.GRID / 100

    return Vector3.New(pos_x, pos_y, 0)
end

function Grid:ctor(land, pos_x, pos_y)
    self.Land   = land

    self.PosX   = pos_x
    self.PosY   = pos_y
end

function Grid:CenterPos()
    return Battle.Grid.GetPos(self.PosX, self.PosY)
end

function Grid:Display(parent)

end


function Grid:Update(deltatime)
    
end



return Grid