 --宣传

local Propaganda = Class.define("Data.Propaganda")


function Propaganda:SyncMSG(msg)
    if msg.Budget ~= nil then
        self.Budget     = msg.Budget
    end   
    
    if msg.Adverts ~= nil then
        for _,cfg in ipairs(msg.Adverts) do
            local advert    = self:GetAdvert(cfg.ID)
            assert(advert, "advert is nil : " .. tostring(cfg.ID))

            advert:SyncMSG(cfg)
        end
    end
end

function Propaganda:ctor()
    self.Budget     = 0
    self.BudgetMax  = 1000000


    self.Adverts    = Class.new(Array)
    self.AdvertDic  = {}
    Table.Each(Table.AdvertTable, function(cfg)
        local ad    = Class.new(Data.Advert, cfg)
        self.Adverts:Add(ad)
        self.AdvertDic[ad.ID] = ad      
    end)

    self.Adverts:SortBy("ID", false)

    LuaEventManager.AddHandler(_E.DATE_FINISH_WEEK ,   self.OnWeekFinished,   self,   self)
end

function Propaganda:GetAdverts()
    return self.Adverts
end

function Propaganda:GetAdvert(id)
    return self.AdvertDic[id]    
end

function Propaganda:UpdateBudget(value)
    self.Budget = value
end

function Propaganda:Payment()
    if self.Budget <= 0 then
        return
    end

    if Controller.Data.IsMoneyEnough(self.Budget) == false then
        Controller.System.ShowNotice("宣传费用不足")
        return
    end

    local count = math.ceil(self.Budget / 65)

    Controller.Data.UpdateMoney(-self.Budget)
    Controller.Data.Fans():UpdateFans(count)

    Controller.System.ShowNotice("支付宣传费用：" .. SetShowNumber(self.Budget))
end

function Propaganda:Update(deltaTime)

end


function Propaganda:OnWeekFinished(event)
    self:Payment()
end


return Propaganda