--战场格子 => 起点

local Spawn = Class.define("Battle.Spawn", Battle.Grid)

function Spawn:ctor(land, pos_cfg)
    super(Battle.Spawn, self, "ctor", land, pos_cfg)
end

function Spawn:Display(parent)
    self.Entity = AssetManager:LoadSync("Prefab/Battle/Spawn")
    self.Entity.transform:SetParent(Battle.FIELD.Land.Avatar.Entity.transform)
    self.Entity.transform.localScale      = Vector3.New(_C.CONST.LAND.GRID / 100.0, _C.CONST.LAND.GRID / 100.0, 0)
    self.Entity.transform.localPosition   = self.Pos
end


function Spawn:Update(deltatime)
    
end



return Spawn