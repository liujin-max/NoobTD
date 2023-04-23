--战场格子
-- => 路线格子

local Route = Class.define("Battle.Route", Battle.Grid)

function Route:ctor(land, pos_x, pos_y)
    super(Battle.Route, self, "ctor", land, pos_x, pos_y)

end

function Route:Display()
    self.Entity = AssetManager:LoadSync("Prefab/Battle/Route")
    self.Entity.transform:SetParent(Battle.FIELD.Land.Avatar.Root.transform)
    self.Entity.transform.localScale      = Vector3.New(_C.CONST.LAND.GRID / 100.0, _C.CONST.LAND.GRID / 100.0, 0)
    self.Entity.transform.localPosition   = self.Pos
end

function Route:Update(deltatime)
    
end



return Route