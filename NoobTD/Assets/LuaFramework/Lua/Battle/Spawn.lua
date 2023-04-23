--战场格子 => 起点

local Spawn = Class.define("Battle.Spawn", Battle.Grid)

function Spawn:ctor(land, pos_x, pos_y)
    super(Battle.Spawn, self, "ctor", land, pos_x, pos_y)
end

function Spawn:Display(parent)
    self.Entity = AssetManager:LoadSync("Prefab/Battle/Spawn")
    self.Entity.transform:SetParent(Battle.FIELD.Land.Avatar.Root.transform)
    self.Entity.transform.localScale      = Vector3.New(_C.CONST.LAND.GRID / 100.0, _C.CONST.LAND.GRID / 100.0, 0)
    self.Entity.transform.localPosition   = Battle.Grid.GetPos(self.PosX, self.PosY)
end


function Spawn:Update(deltatime)
    
end



return Spawn