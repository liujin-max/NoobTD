--战场布阵 管理类
local FormatHandler = Class.define("Battle.FormatHandler")


function FormatHandler:ctor(field)
    self.Field      = field

    self.DetectRange= nil
    
    self.Model      = nil

end

--展示范围
function FormatHandler:ShowRange(flag, id , pos)
    if flag == true then
        if self.DetectRange == nil then
            self.DetectRange    = Class.new(Display.DetectRange, self.Field)
        end

        local range         = 0
        local tower_cfg     = Table.Get(Table.TowerTable, id)
        local sk_cfg        = Table.Get(Table.SkillTable, tower_cfg.Skills[1])

        if sk_cfg ~= nil then
            range           = sk_cfg.Range
        end

        self.DetectRange:Show(true, range, pos)
    else
        if self.DetectRange ~= nil then
            self.DetectRange:Show(false)
        end
    end    
end

--预建造
function FormatHandler:Preload(id, defender)
    if self.Model ~= nil then
        self.Model:Dispose()
        self.Model  = nil
    end

    local tower   = Class.new(Battle.Tower, Table.Get(Table.TowerTable, id), _C.SIDE.DEFEND)
    tower.Avatar:Decorate()
    tower.Avatar:TurnAlpha(0.5)

    tower:SetPos(defender:CenterPos())

    self:ShowRange(true , id, tower:GetPos())

    self.Model  = tower
end

--取消预建造
function FormatHandler:Cancel()
    if self.DetectRange ~= nil then
        self.DetectRange:Show(false)
    end

    if self.Model ~= nil then
        self.Model:Dispose()
        self.Model  = nil
    end
end

--建造塔
function FormatHandler:Build(id, defender)
    if defender:GetTower() ~= nil then return end
    
    local cost      = Logic.Battle.GetTowerCost(id)

    if Battle.FIELD:GetCoin() < cost then
        Controller.System.FlyTip(_C.MESSAGE.COINERROR)
        return
    end

    Battle.FIELD:UpdateCoin(-cost)

    local tower   = Class.new(Battle.Tower, Table.Get(Table.TowerTable, id), _C.SIDE.DEFEND)
    tower:SetDefender(defender)
    defender:SetTower(tower)
    
    tower:InitBehaviour()

    self.Field.Positioner:PushTower(tower)
end

--升级塔
--升级
function FormatHandler:Upgrade(tower, next_id)
    local cost      = Logic.Battle.GetTowerCost(next_id)

    if Battle.FIELD:GetCoin() < cost then
        Controller.System.FlyTip(_C.MESSAGE.COINERROR)
        return
    end

    Battle.FIELD:UpdateCoin(-cost)

    self:Transform(tower, next_id)
end

--转换、变身
function FormatHandler:Transform(unit, id)
    local config    = Table.Get(Table.TowerTable, id)

    local playing_skill = unit:GetCastingSkill()
    if playing_skill ~= nil then
        playing_skill:Interrupt()
    end

    unit:CleanBuff()

    unit:ReBuild(config)

    unit.Avatar:Transform()
end


function FormatHandler:Update(deltatime)

end

function FormatHandler:Dispose()
    if self.Model ~= nil then
        self.Model:Dispose()
    end
    self.Model  = nil
end

return FormatHandler