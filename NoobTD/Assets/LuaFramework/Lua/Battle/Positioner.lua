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
    local line      = self.Field.Land:GetLines():First()
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

    local unit_gc   = Class.new(Array)

    self.Towers:Each(function(u)
        u:Update(deltatime)

        if u:IsGC() == true then
            unit_gc:Add(u)
        end
    end)

    self.Monsters:Each(function(u)
        u:Update(deltatime)

        if u:IsGC() == true then
            unit_gc:Add(u)
        end
    end)

    for i = unit_gc:Count(), 1, -1 do
        local u = unit_gc:Get(i)

        self.Towers:Remove(u)
        self.Monsters:Remove(u)

        u:Dispose()
    end
end

function Positioner:Dispose()
    self.Towers:Each(function(u)
        u:Dispose()        
    end)
    self.Towers:Clear()

    self.Monsters:Each(function(u)
        u:Dispose()        
    end)
    self.Monsters:Clear()
end

return Positioner