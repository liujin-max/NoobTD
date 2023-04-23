--状态播放

local News = Class.define("Data.News")


function News:SyncMSG(msg)
    if msg.Reports ~= nil then
        self.Reports:Clear()

        for _,cfg in ipairs(msg.Reports) do
            local report    = Class.new(Data.Report, 0)
            report:SyncMSG(cfg)
            
            self.Reports:Add(report)
        end
    end    
end

function News:ctor()
    self.Reports    = Class.new(Array)
    self.Messages   = Class.new(Array)

    LuaEventManager.AddHandler(_E.NEWS_PUSHREPORT,          self.OnPushReport,          self, self)


    --游戏发行
    LuaEventManager.AddHandler(_E.GAME_RELEASE_START,       self.OnGameReleaseStart,    self, self)
    LuaEventManager.AddHandler(_E.GAME_RELEASE_SHOW,        self.OnGameReleaseShow,     self, self)
    LuaEventManager.AddHandler(_E.GAME_RELEASE_END,         self.OnGameReleaseEnd,      self, self)
    LuaEventManager.AddHandler(_E.GAME_RELEASE_WEEK,        self.OnGameReleaseWeek,     self, self)

    LuaEventManager.AddHandler(_E.NEWS_GAMESCORE,           self.OnGameNewScore,        self, self)

    --游戏续作
    LuaEventManager.AddHandler(_E.GAME_SEQUEL_CHECK,        self.OnGameSequelCheck,     self, self)

    --员工
    LuaEventManager.AddHandler(_E.STAFF_HIRE,               self.OnStaffHire,           self, self)
    LuaEventManager.AddHandler(_E.STAFF_FIRE,               self.OnStaffFire,           self, self)

    --主机
    LuaEventManager.AddHandler(_E.HARDWARE_BUILDING_END,    self.OnConsoleBuildEnd,     self, self)
    LuaEventManager.AddHandler(_E.CONSOLE_RELEASE_START,    self.OnConsoleReleaseStart, self, self)
    LuaEventManager.AddHandler(_E.CONSOLE_RELEASE_END,      self.OnConsoleReleaseEnd,   self, self)
end

function News:GetReports()
    return self.Reports
end

function News:AddReport(times, description)
    local report    = Class.new(Data.Report, times, description)
    self.Reports:Add(report)
end

function News:OnPushReport(event, params)
    local times     = params.Times
    local des       = params.Desc

    self:AddReport(times, des)
end

function News:GetMessages()
    return self.Messages
end

function News:AddMessage(message_data)
    local message   = Class.new(Data.Message, message_data)
    self.Messages:Add(message)

    LuaEventManager.SendEvent(_E.M2U_MESSAGE_PUSH, nil, message)
end

function News:RemoveMessage(message)
    self.Messages:Remove(message)

    LuaEventManager.SendEvent(_E.M2U_MESSAGE_POP, nil, message)
end


function News:Update(deltaTime)
    for i = self.Reports:Count() , 1, -1 do
        local report = self.Reports:Get(i)
        report:Update(deltaTime)

        if report:IsFinished() == true then
            report:Execute()
            
            self.Reports:Remove(report)
        end
    end
end



----------------------------------------------------------------------------------------------------------------------------------------
function News:OnGameReleaseStart(event, game)
    local game_type     = game.Type
    local game_theme    = game.Theme

    if game:IsNetwork() == true then
        local description = string.format("%s 终于上线啦! 预计运营时长是%d周\n\n它的表现会如何呢,让我们拭目以待吧!", game.Name, _C.CONST.SELLTIMENETWORK)
        Controller.System.Popup(description, function()
            return true
        end, nil, true)

    else
        local description = "%s 开始发售啦!\n %s和%s的组合，不知道会有怎样的表现呢"
        Controller.System.Popup(string.format(description, game.Name, game_type.Name, game_theme.Name), function()
            return true
        end, nil, true)
    end
end

function News:OnGameReleaseShow(event, game)
    if game:IsNetwork() == true then    --网络游戏
        local sell_logic    = game.GameSellLogic
        local sell_times    = sell_logic.SellTimes

        local total         = sell_times:GetTotal() / _C.CONST.WEEKSECOND
        local now           = sell_times:GetCurrent() / _C.CONST.WEEKSECOND

        if now >= (total - 11) and now < (total - 10) and game.NetworkTip ~= true then
            local suplus    = math.floor(total - now)

            local description = string.format("%s 将在%d周后退出市场\n注意规划好开发节奏哦~", game.Name, suplus)
            Controller.System.Popup(description, function()
                game.NetworkTip = true
                return true
            end, nil, true)
        end
    else    --单机游戏

    end
end

function News:OnGameReleaseEnd(event, game)
    if game:IsNetwork() == true then
        local description = string.format("%s 的销售结束了\n\n 销售持续了%d周,销售额为%s元", game.Name, #game.GameSellLogic.SalesInfo - 1, SetShowNumber(game.GameSellLogic:GetSaleMoney()))
        Controller.System.Popup(description, function()
            return true
        end, nil, true)
    else
        local description = "%s 的销售结束了\n\n销售数量是%s套"
        Controller.System.Popup(string.format(description, game.Name, SetShowNumber(game.GameSellLogic:GetSalesVolume())), function()
            return true
        end, nil, true)
    end
end

function News:OnGameNewScore(event, game, old_game)
    local str = string.format("正在销售的 <#FF180F>%s</color> 创下了新的销售记录！！！", game.Name)
    LuaEventManager.SendEvent(_E.M2U_SHOWNEWS, nil, str, 5)

    local week = #game.GameSellLogic.SalesInfo
    if week <= 5 then
        local description = string.format("插播一条令人振奋的消息！！ \n%s 仅用了%d周时间就打破了由 %s 保持的销售记录！！\n不知道最终可以卖出多少份呢..", game.Name, week, old_game.Name)
        LuaEventManager.SendEvent(_E.NEWS_PUSHREPORT, nil, {Times = Utility.Random.Range(2, 4), Desc = description})
    end
end

--每周的销售周期
function News:OnGameReleaseWeek(event, sell_logic)
    local game  = sell_logic.Game

    if game:IsNetwork() == true then
        
    else
        --首周结束
        local sale_info = sell_logic:GetSalesInfo()
        if #sale_info == 1 then
            local game          = sell_logic.Game
            local fetter        = game.Fetter
            local game_type     = game.Type
            local game_theme    = game.Theme

            local rand_first    = Utility.Random.Range(1, 100)
            local description   = "%s 的首周销量为%s套"

            if rand_first <= 30 then
                if fetter.ID == _C.FETTER.RANGE or fetter.ID == _C.FETTER.BAD or fetter.ID == _C.FETTER.NORMAL then
                    description = "%s 在第首周仅卖出了%s套"
                    description = description .. string.format("\n%s和%s的搭配实在不尽如人意", game_type.Name, game_theme.Name)
                end
            elseif rand_first <= 60 then
                description     = "%s 第一周卖出了%s套"
            end


            local end_des   = "\n让我们期待它的后续表现吧!"

            if fetter.ID == _C.FETTER.MIRACLE then  --奇迹
                end_des     = "\n让我们期待它的后续表现吧!"

            elseif fetter.ID == _C.FETTER.RANGE or fetter.ID == _C.FETTER.BAD or fetter.ID == _C.FETTER.NORMAL then
                end_des     = "\n不知道后续的走势会如何呢"

            else

            end



            description         = description .. end_des
            Controller.System.Popup(string.format(description, game.Name, SetShowNumber(sell_logic:GetSalesVolume())), function()
                return true
            end, nil, true)
        end
    end
end

--游戏入选续作开发
function News:OnGameSequelCheck(event, game)
    if Controller.Data.Account().History.SequelCum == 1 then
        --首次有作品入选续作

        local description   = string.format("恭喜你制作出了首款殿堂级作品\n<%s>\n\n我们将可以为它开发续作!", game.Name)
        Controller.System.Popup(description, function()
            return true
        end, nil, true)
    end
end


--@region 员工
--雇佣
function News:OnStaffHire(event, staff)
    local description   = staff.HireDes or ""
    description         = string.gsub(description, "$n", Controller.Data.Account():GetCompany().Name)
    if description ~= "" then
        Controller.System.Popup(description, function()
            return true
        end, nil, true)
    end
end

--解雇
function News:OnStaffFire(event, staff)
    local description   = staff.FireDes or ""
    description         = string.gsub(description, "$n", Controller.Data.Account():GetCompany().Name)
    if description ~= "" then
        Controller.System.Popup(description, function()
            return true
        end, nil, true)
    end
end

--@endregion


--@region 主机
--主机制作完成
function News:OnConsoleBuildEnd(event, console)

end

--主机开始销售
function News:OnConsoleReleaseStart(event, console)
    local count = Controller.Data.Account().History:GetConsoles():Count()

    local cpu   = console.CPU
    local gpu   = console.GPU
    local ram   = console.RAM

    local cpu_des   = ""
    if cpu.Level < gpu.Level then
        cpu_des = string.format("%s显卡搭配%s处理器，恐怕无法发挥出最佳性能哦", gpu.Name, cpu.Name)
    end


    local description   = string.format("第%d台自产主机%s开始发售了！", count, console.Name)
    description         = description .. "\n" .. cpu_des

    Controller.System.Popup(description, nil, nil, true)
end

--主机销售结束
function News:OnConsoleReleaseEnd(event, console)
    local description   = string.format("%s退出市场了", console.Name)

    Controller.System.Popup(description, nil, nil, true)
end

--@endregion



return News