--战场单位管理类
local Positioner = Class.define("Battle.Positioner")


function Positioner:ctor(field)
    self.Field      = field

    self.Towers     = Class.new(Array)
    self.Monsters   = Class.new(Array)


end

function Positioner:PushTower(t)
    self.Towers:Add(t)
end

function Positioner:RemoveTower(t)
    t:Dispose()

    self.Towers:Remove(t)
end

function Positioner:PushMonster(m)
    self.Monsters:Add(m)
end

function Positioner:GetUnits(side, pick_id)
    if side == _C.SIDE.ATTACK then
        if pick_id == _C.SKILL.PICK.ALLY then
            return self.Monsters
        else
            return self.Towers
        end

    elseif side == _C.SIDE.DEFEND then
        if pick_id == _C.SKILL.PICK.ALLY then
            return self.Towers
        else
            return self.Monsters
        end
    end    

    return nil
end

function Positioner:Update(deltatime)
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