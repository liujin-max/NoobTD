--负责外包的制作逻辑

local Farm = Class.define("Data.Farm")



function Farm:SyncMSG(msg)
    if msg.Waiting ~= nil then
        self.Waiting:Set(msg.Waiting.Value, msg.Waiting.Total)
    end

    if msg.Actives ~= nil then
        self.Actives:Clear()

        for _,cfg in ipairs(msg.Actives) do
            local source = self:GetOutsource(cfg.ID)
            assert(source, "source is nil :  " .. tostring(cfg.ID))

            source:SyncMSG(cfg)
            self.Actives:Add(source)
        end
    else
        self:PickActives()
    end

    if msg.ActingOutsource ~= nil then
        local source = self:GetOutsource(msg.ActingOutsource.ID)
        assert(source, "source is nil :  " .. tostring(msg.ActingOutsource.ID))

        source:SyncMSG(msg.ActingOutsource)

        self.ActingOutsource    = source

        LuaEventManager.SendEvent(_E.OUTSOURCE_BUILDING_START, nil, source)
    end
end

function Farm:ctor()
    self.ActingOutsource = nil
    self.Waiting        = Class.new(Logic.CDTimer, 1)


    self.Actives        = Class.new(Array)      --每周生成3个委托供玩家选择
    self.Outsources     = Class.new(Array)
    self.OutsourceDic   = {}

    Table.Each(Table.OutsourceTable, function(cfg)
        local out_source= Class.new(Data.Outsource, cfg)
        self.Outsources:Add(out_source)
        self.OutsourceDic[out_source.ID] = out_source
    end)


    LuaEventManager.AddHandler(_E.DATE_FINISH_WEEK, self.DateWeekFinish,    self,   self)
end

function Farm:GetOutsource(id)
    return self.OutsourceDic[id]    
end

function Farm:GetActingOutsource()
    return self.ActingOutsource
end

function Farm:PickActives()
    local company_level = Controller.Data.Account():GetCompany():GetLevel()

    local picked    = Utility.Random.Pick(3, self.Outsources, function(s)
        if s.Level > company_level then
            return false
        end

        if self.ActingOutsource == nil then
            return true
        end
        return s.ID ~= self.ActingOutsource.ID
    end)
    self.Actives:Clear()

    picked:Each(function(s)
        s:Reset()
        self.Actives:Add(s)
    end)
end

function Farm:New(outsource)
    if self.ActingOutsource ~= nil then
        return
    end

    self.Actives:Remove(outsource)

    self.ActingOutsource  = outsource
    
    local staffs    = Controller.Data.Account():GetCompany():GetStaffs()
    staffs:Each(function(staff)
        staff:OUTSOURCE_Start()
    end)

    LuaEventManager.SendEvent(_E.OUTSOURCE_BUILDING_START, nil, outsource)
end

function Farm:Update()
    if self.ActingOutsource == nil then
        return
    end
    local delta_time = Time.deltaTime

    self:StaffWorking(delta_time)

    --制作完成
    if self.ActingOutsource:IsFinished() == true then
        self.Waiting:Update(delta_time)
        if self.Waiting:IsFinished() == true then
            self.Waiting:Reset()
            
            local reward    = self.ActingOutsource:GetReward()
            local coin      = self.ActingOutsource:GetCoin()
            Controller.Data.Account():UpdateResearch(reward)
            Controller.Data.UpdateMoney(coin)

            Controller.System.Popup("获得报酬：\n" .. reward .. " 科技点\n" .. coin .. " 金钱", function()
                
            end, nil, true)
            Logic.MusicPlayer.PlaySound(SOUND.COIN)
    
            LuaEventManager.SendEvent(_E.OUTSOURCE_BUILDING_END, nil, self.ActingOutsource)
    
            self.ActingOutsource:Reset()
            self.ActingOutsource    = nil 
        end
    end

    --时间到了
    if self.ActingOutsource ~= nil then
        if self.ActingOutsource.CDTimer:IsFinished() == true then
            if self.ActingOutsource:IsFinished() == false then
                local coin = self.ActingOutsource:GetCoin() * 3
                Controller.Data.UpdateMoney(-coin)
                Controller.System.Popup("我们未能在期限内交付作品，支付 " .. coin .. " 违约金", function()
                    
                end, nil, true)

                Logic.MusicPlayer.PlaySound(SOUND.PAY)

                LuaEventManager.SendEvent(_E.OUTSOURCE_BUILDING_END, nil, self.ActingOutsource)

                self.ActingOutsource:Reset()
                self.ActingOutsource    = nil 
            end
        end        
    end

end

function Farm:StaffWorking(delta_time)
    self.ActingOutsource.CDTimer:Update(delta_time)

    local staffs        = Controller.Data.Account():GetCompany():GetStaffs()
    staffs:Each(function(staff)
        staff:OUTSOURCE_Update(self.ActingOutsource, delta_time)
    end)

    LuaEventManager.SendEvent(_E.OUTSOURCE_BUILDING_SHOW, nil, self.ActingOutsource)
end



function Farm:DateWeekFinish(event)
    self:PickActives()
end


return Farm