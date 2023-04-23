--开发侧重点

local GameDevelop = Class.define("Data.GameDevelop")



--策划阶段 => 内购|买断, 玩法|剧情, 休闲|资深
--美术阶段 => 二维|三维, 卡通|写实, 朴实|华丽

function GameDevelop:GetDevelopTable()
    return self.Develops
end

function GameDevelop:SyncMSG(msg)
    if msg.Develops ~= nil then
        for _,cfg in ipairs(msg.Develops) do
            self:UpdateDevelop(cfg.ID, cfg.Value)
        end
    end    
end

function GameDevelop:ctor(game)
    self.Game       = game
    --开发方向
    self.Develops   = {}
    for k,v in pairs(_C.GAME.DEVELOP) do
        self.Develops[v] = 1
    end
end

function GameDevelop:UpdateDevelop(develop_type, value)
    self.Develops[develop_type] = value
end




return GameDevelop