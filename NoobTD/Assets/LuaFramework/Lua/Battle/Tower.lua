--防御塔

local Tower = Class.define("Battle.Tower")

function Tower:ctor(cfg)
    self.ID     = 10000

    
    --防守位
    self.Defender   = nil
end

function Tower:Decorate()
    self.Avatar = Class.new(Display.Avatar, self)
    self.Avatar:Decorate()
end

function Tower:SetDefender(defender)
    self.Defender   = defender
end

function Tower:Update(deltatime)

end



return Tower