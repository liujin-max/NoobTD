--一波怪物
--负责出怪逻辑
--出怪应该是个怎样的逻辑呢？ 还没想好
--根据时间点出怪
--还是类似kindomrush那样
--先做个时间出怪吧

local Wave = Class.define("Battle.Wave")

--结构
-- {
--     wait    = 0,
--     list    =
--     {
--         {time = 0.0, id = 910000}, {time = 1.0, id = 910000},{time = 2.0, id = 910000},{time = 3.0, id = 910000},
--         {time = 5.0, id = 910000}, {time = 6.0, id = 910000},{time = 7.0, id = 910000},{time = 8.0, id = 910000},
--     }
-- }

function Wave:ctor(cfg, order)
    self.Order  = order

    self.Timer  = Class.new(Logic.CDTimer, cfg.wait)

    self.Exorcists  = Class.new(Array)
    for i,v in ipairs(cfg.list) do
        self.Exorcists:Add({Timer = Class.new(Logic.CDTimer, v.time), ID = v.id})
    end
end

--怪物诞生
function Wave:Spawn(cfg)
    local monster   = Class.new(Battle.Monster, Table.Get(Table.MonsterTable, cfg.ID), _C.SIDE.ATTACK)
    local line      = Battle.FIELD.Land:GetLines():First()
    monster:SetRouteLine(line)
    monster:SetRouteIndex(1)
    monster:InitBehaviour()

    Battle.FIELD.Positioner:PushMonster(monster)
end

function Wave:Update(deltatime)
    self.Timer:Update(deltatime)

    if self.Timer:IsFinished() == true then
        for i = self.Exorcists:Count(), 1, -1 do
            local cfg = self.Exorcists:Get(i)
            cfg.Timer:Update(deltatime)

            if cfg.Timer:IsFinished() == true then
                self:Spawn(cfg)

                self.Exorcists:Remove(cfg)
            end
        end
    end
end


return Wave