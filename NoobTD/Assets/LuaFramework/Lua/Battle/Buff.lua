--Buff
--区分逻辑id和表现id
--


local Buff = Class.define("Battle.Buff")


function Buff:ctor(id, owner, caster)
    self.Table      = Table.Get(Table.BuffTable, id)
    self.ID         = id
    self.Owner      = owner
    self.Caster     = caster

    self.EntityID   = self.Table.EntityID
    -- self.Show
end


function Buff:Update(deltatime)

end



return Buff