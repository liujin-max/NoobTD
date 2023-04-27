--防守位

local Defender = Class.define("Battle.Defender", Battle.Grid)

function Defender:ctor(land, pos_cfg)
    super(Battle.Defender, self, "ctor", land, pos_cfg)

    self.Tower  = nil
end

function Defender:Decorate()
    self.Entity = AssetManager:LoadSync("Prefab/Battle/Defender")
    self.Entity.transform:SetParent(Battle.FIELD.Land.Avatar.Root.transform)
    self.Entity.transform.localScale      = Vector3.one
    self.Entity.transform.localPosition   = self.Pos
end

function Defender:SetTower(tower)
    self.Tower = tower
end

function Defender:GetTower()
    return self.Tower
end

function Defender:Update(deltatime)
    
end



return Defender