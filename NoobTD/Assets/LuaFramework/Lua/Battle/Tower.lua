--防御塔

local Tower = Class.define("Battle.Tower", Battle.Unit)

function Tower:ctor(cfg, side)
    super(Battle.Tower, self, "ctor", cfg, side)

    self.BuildEffects   = ParseEventEffect(cfg.BuildEffect)
    --防守位
    self.Defender       = nil
end

function Tower:SetDefender(defender)
    self.Defender   = defender
end

function Tower:GetDefender()
    return self.Defender
end

function Tower:InitBehaviour()
    self.Behaviour  = Class.new(Battle.TowerBehaviour, self)
end

function Tower:GetBuildEffects()
    return self.BuildEffects
end



return Tower