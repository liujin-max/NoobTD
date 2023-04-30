--防守位

local Defender = Class.define("Battle.Defender", Battle.Grid)

function Defender:ctor(land, pos_cfg)
    super(Battle.Defender, self, "ctor", land, pos_cfg)

    self.Tower  = nil
    self.Comp   = nil
end

function Defender:Decorate()
    self.Avatar = Class.new(Display.Defender, self)
    self.Avatar:Decorate()
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