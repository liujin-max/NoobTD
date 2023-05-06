--一波怪物
--负责出怪逻辑
--手动出怪
--1波结束后，下一波进入倒计时，在出口显示怪物标记

local Wave = Class.define("Battle.Wave")


function Wave:ctor(cfg, order)
    self.Order  = order

    self.Timer  = Class.new(Logic.CDTimer, cfg.wait / 100.0)

    self.Exorcists  = Class.new(Array)
    for i,v in ipairs(cfg.list) do
        self.Exorcists:Add({Timer = Class.new(Logic.CDTimer, v.time), ID = v.id})
    end

    self.StartFlag  = false
end

--可以手动Start
--或者Timer计时到了，自动Start
function Wave:Start()
    self.StartFlag  = true
end

function Wave:IsStart()
    return self.StartFlag
end

--怪物数量
function Wave:MonsterCount()
    return self.Exorcists:Count()
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
    if self:IsStart() == true then
        for i = self.Exorcists:Count(), 1, -1 do
            local cfg = self.Exorcists:Get(i)
            cfg.Timer:Update(deltatime)

            if cfg.Timer:IsFinished() == true then
                self:Spawn(cfg)

                self.Exorcists:Remove(cfg)
            end
        end
    else
        self.Timer:Update(deltatime)
        if self.Timer:IsFinished() == true then
            self:Start()
        end
    end

end


return Wave