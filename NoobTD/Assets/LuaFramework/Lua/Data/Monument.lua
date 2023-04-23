
local Monument = Class.define("Data.Monument")

function Monument:GetCompanys()
    return self.Companys
end

function Monument:ctor()
    self.MoneyCycle = Class.new(Logic.CDTimer,  _C.CONST.WEEKSECOND * 8)
    self.GameCycle  = Class.new(Logic.CDTimer,  _C.CONST.WEEKSECOND * 16)
    self.Interval   = Class.new(Logic.CDTimer,  _C.CONST.WEEKSECOND)



    self.Companys   = Class.new(Array)
    
    Table.Each(Table.CompanyTable, function(config)
        if config.IsMy ~= 1 then
            local c     = Class.new(Data.Company, config)
            c.Weight    = 10
            self.Companys:Add(c)
        end
    end)

    self:RandomMoney()
    self:SortCompanys()
end

function Monument:SortCompanys()
    self.Companys:SortBy("Money", true)
end

function Monument:RandomMoney()
    self.Companys:Each(function(c)
        c.Money = Utility.Random.Range(66666666, 88888888)
    end)
end

function Monument:RandomBuildGame()
    local company   = Utility.Random.ArrayWeightedPick("Weight", self.Companys)
    self.Companys:Each(function(c)
        if c == company then
            c.Weight    = 10
        else
            c.Weight    = c.Weight + 5
        end
    end)
    company:NewRandomGame()
end

function Monument:Update(delta_time)
    --每隔一段周期，市值发生变化
    self.MoneyCycle:Update(delta_time)
    if self.MoneyCycle:IsFinished() == true then
        self.MoneyCycle:Reset()

        self.Companys:Each(function(c)
            local money = c:GetMoney()
            local count = money * (Utility.Random.Range(-5,10) / 100.0)
            c:UpdateMoney(count)
        end)

        self:SortCompanys()
    end

    --每隔一段周期，生成一款产品
    -- self.GameCycle:Update(delta_time)
    -- self.Interval:Update(delta_time)

    -- if self.Interval:IsFinished() == true then
    --     self.Interval:Reset()

    --     if Utility.Random.IsHit(self.GameCycle:GetCurrent()) == true then
    --         self.GameCycle:Reset()
    
    --         self:RandomBuildGame()
    --     end
    -- end

    -- if self.GameCycle:IsFinished() == true then
    --     self.GameCycle:Reset()

    --     self:RandomBuildGame()
    -- end
end


return Monument