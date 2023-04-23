--游戏推广业务

local Advert = Class.define("Data.Advert")


function Advert:SyncMSG(msg)
    
end

function Advert:ctor(config)
    self.ID         = config.ID
    self.Name       = config.Name
    self.Cost       = config.cost

    self.Conditions = ParseConditions(config.condition)
end

function Advert:IsUnlock()
    for i = 1, self.Conditions:Count() do
        local condition = self.Conditions:Get(i)
        if condition:Check() == false then
            return false
        end
    end
    return true
end

function Advert:GetCost()
    return self.Cost
end

function Advert:Execute(game)
    print("测试输出 推广游戏：" .. game.Name)
end


return Advert