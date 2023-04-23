--主机子物件的基类

local ConsoleElement = Class.define("Data.ConsoleElement")


function ConsoleElement:ctor(config)
    self.ID             = config.ID
    self.Name           = config.Name
    self.Cost           = config.Cost
    self.Level          = config.Level
    self.Speed          = config.Speed
    self.MakeCost       = config.MakeCost
    self.Time           = config.Time

end

function ConsoleElement:GetCost()
    return self.Cost
end

function ConsoleElement:IsUnlock()
    return true
end

function ConsoleElement:GetMakeCost()
    return self.MakeCost
end

function ConsoleElement:GetSpeed()
    return self.Speed
end

function ConsoleElement:GetTime()
    return self.Time
end

function ConsoleElement:Select()
    
end


return ConsoleElement