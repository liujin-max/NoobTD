--战场格子 => 终点

local Exit = Class.define("Battle.Exit", Battle.Grid)

function Exit:ctor(land, pos_cfg)
    super(Battle.Exit, self, "ctor", land, pos_cfg)
end

function Exit:Display(parent)
    self.Entity = AssetManager:LoadSync("Prefab/Battle/Exit")
    self.Entity.transform:SetParent(Battle.FIELD.Land.Avatar.Entity.transform)
    self.Entity.transform.localScale      = Vector3.New(_C.CONST.LAND.GRID / 100.0, _C.CONST.LAND.GRID / 100.0, 0)
    self.Entity.transform.localPosition   = self.Pos
end


function Exit:Update(deltatime)
    
end



return Exit