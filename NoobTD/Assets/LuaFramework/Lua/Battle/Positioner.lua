--战场单位管理类
local Positioner = Class.define("Battle.Positioner")


function Positioner:ctor(field)
    self.Field      = field

    self.Towers     = Class.new(Array)
    self.Monsters   = Class.new(Array)

    
    self.Timer      = Class.new(Logic.CDTimer, 1.0)
end

function Positioner:Born()
    local monster   = Class.new(Battle.Monster)
    local line      = self.Field.Land:GetLine()
    monster:SetRouteLine(line)
    monster:SetRouteIndex(1)

    local route     = monster:GetCurrentRoute()

    monster:Decorate()
    monster.Avatar:SetPosition(route:CenterPos())

    self.Monsters:Add(monster)
end

function Positioner:Update(deltatime)
    self.Timer:Update(deltatime)
    if self.Timer:IsFinished() == true then
        self.Timer:Reset()

        self:Born()
    end


    self.Monsters:Each(function(m)
        m:Update(deltatime)
    end)
end

function Positioner:Dispose()
    
end

return Positioner