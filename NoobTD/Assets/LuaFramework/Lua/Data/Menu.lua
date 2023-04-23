--用于查找建造游戏需要用到的数据

local Menu = Class.define("Data.Menu")


function Menu:SyncMSG(msg)
    if msg.GameTypes ~= nil then
        for _, cfg in ipairs(msg.GameTypes) do
            local g_type    = self.TypeDic[cfg.ID]
            assert(g_type, "game type is nil : " .. tostring(cfg.ID))
            g_type:SyncMSG(cfg)
        end
    end  
    
    if msg.GameThemes ~= nil then
        for _, cfg in ipairs(msg.GameThemes) do
            local g_theme    = self.ThemeDic[cfg.ID]
            assert(g_theme, "game theme is nil : " .. tostring(cfg.ID))
            g_theme:SyncMSG(cfg)
        end
    end 

    if msg.GameConsoles ~= nil then
        for _, cfg in ipairs(msg.GameConsoles) do
            local g_console    = self.GameConsoleDic[cfg.ID]
            if g_console ~= nil then
                assert(g_console, "game console is nil : " .. tostring(cfg.ID))
                g_console:SyncMSG(cfg) 
            end
        end
    end 

    if msg.FetterDic ~= nil then
        self.FetterDic  = {}
        for _,cfg in ipairs(msg.FetterDic) do
            if self.FetterDic[cfg.Type] == nil then
                self.FetterDic[cfg.Type]    = {}
            end

            self.FetterDic[cfg.Type][cfg.Theme] = true
        end
    end


end

function Menu:ctor()
    self.CheckInterval  = Class.new(Logic.CDTimer,  1)
    --相性记录
    self.FetterDic      = {}

    --职业类型
    self.Jobs           = Class.new(Array)
    self.JobDic         = {}

    Table.Each(Table.JobTable, function(config)
        local job       = Class.new(Data.Job, config)
        self.Jobs:Add(job)
        self.JobDic[job.ID] = job
    end)


    --游戏类型
    self.GameTypes      = Class.new(Array)
    self.TypeDic        = {}

    Table.Each(Table.GameTypeTable, function(cfg)
        local game_type = Class.new(Data.GameType, cfg)

        self.GameTypes:Add(game_type)
        self.TypeDic[game_type.ID] = game_type
    end)

    --游戏主题
    self.GameThemes     = Class.new(Array)
    self.ThemeDic       = {}

    Table.Each(Table.GameThemeTable, function(cfg)
        local game_theme = Class.new(Data.GameTheme, cfg)
        
        self.GameThemes:Add(game_theme)
        self.ThemeDic[game_theme.ID] = game_theme
    end)

    --游戏主机
    self.GameConsoles   = Class.new(Array)
    self.GameConsoleDic = {}

    Table.Each(Table.GameConsoleTable, function(cfg)
        local game_console = Class.new(Data.GameConsole, cfg)
        
        self.GameConsoles:Add(game_console)
        self.GameConsoleDic[game_console.ID] = game_console
    end)

    --游戏选项
    self.UIMenus        = Class.new(Array)
    
    Table.Each(Table.MenuTable, function(cfg)
        local ui_menu   = Class.new(Data.UIMenu, cfg)
        self.UIMenus:Add(ui_menu)        
    end)


    --cpu
    self.CPUs           = Class.new(Array)
    self.CPUDic         = {}
    Table.Each(Table.CPUTable, function(cfg)
        local cpu   = Class.new(Data.CPU, cfg)
        self.CPUs:Add(cpu)
        self.CPUDic[cpu.ID] = cpu        
    end)

    --gpu
    self.GPUs           = Class.new(Array)
    self.GPUDic         = {}
    Table.Each(Table.GPUTable, function(cfg)
        local gpu   = Class.new(Data.GPU, cfg)
        self.GPUs:Add(gpu)
        self.GPUDic[gpu.ID] = gpu        
    end)

    --ram
    self.RAMs           = Class.new(Array)
    self.RAMDic         = {}
    Table.Each(Table.RAMTable, function(cfg)
        local ram   = Class.new(Data.RAM, cfg)
        self.RAMs:Add(ram)
        self.RAMDic[ram.ID] = ram        
    end)


    self.UIMenus:SortBy("ID", false)
    self.GameTypes:SortBy("ID", false)
    self.GameThemes:SortBy("ID", false)
    self.GameConsoles:SortBy("ID", false)

    self.CPUs:SortBy("ID", false)
    self.GPUs:SortBy("ID", false)
    self.RAMs:SortBy("ID", false)

    if ConstManager.Console == true then
        -- self:Print()
    end

    LuaEventManager.AddHandler(_E.GAME_BUILDING_END,    self.OnGameBuildingEnd,     self,   self)
    LuaEventManager.AddHandler(_E.GAME_RELEASE_START,   self.OnGameReleaseStart,    self,   self)
    LuaEventManager.AddHandler(_E.STAFF_TRAIN,          self.OnStaffTrain,          self,   self)
end

function Menu:GetJob(id)
    local job   = self.JobDic[id]
    assert(job, "job is nil : " .. tostring(id))
    return job
end

function Menu:GetJobs()
    return self.Jobs
end

function Menu:GetGameConsoles()
    return self.GameConsoles
end

function Menu:GetGameConsole(id)
    return self.GameConsoleDic[id]
end

function Menu:GetGameTypes()
    return self.GameTypes
end

function Menu:GetGameThemes()
    return self.GameThemes
end

function Menu:GetUIMenus()
    return self.UIMenus
end

function Menu:GetGameType(id)
    return self.TypeDic[id]    
end

function Menu:GetGameTheme(id)
    return self.ThemeDic[id]    
end

function Menu:GetCPUs()
    return self.CPUs
end

function Menu:GetGPUs()
    return self.GPUs
end

function Menu:GetRAMs()
    return self.RAMs
end

function Menu:GetCPU(id)
    return self.CPUDic[id]    
end

function Menu:GetGPU(id)
    return self.GPUDic[id]    
end

function Menu:GetRAM(id)
    return self.RAMDic[id]    
end


function Menu:InsertFetter(fetter)
    if self.FetterDic[fetter.Type.ID] == nil then
        self.FetterDic[fetter.Type.ID]  = {}
    end

    self.FetterDic[fetter.Type.ID][fetter.Theme.ID] = true
end

function Menu:GetFetterDic(type, theme)
    if self.FetterDic[type.ID] == nil then
        return nil
    end

    local flag = self.FetterDic[type.ID][theme.ID]
    if flag == nil then
        return nil
    end

    local fetter_id = Data.Fetter.FitterID(type, theme)
    local cfg       = Table.Get(Table.FitterTable, fetter_id)
    return cfg
end

function Menu:GetGameCost(console, type, theme)
    local cost  = 0
    if console ~= nil then
        cost    = cost + console:GetCost()
    end

    if type ~= nil then
        cost    = cost + type:GetCost()
    end

    if theme ~= nil then
        cost    = cost + theme:GetCost()
    end

    return cost
end

function Menu:GetConsoleCost(cpu, gpu, ram)
    local cost  = 0
    if cpu ~= nil then
        cost    = cost + cpu:GetCost()
    end

    if gpu ~= nil then
        cost    = cost + gpu:GetCost()
    end

    if ram ~= nil then
        cost    = cost + ram:GetCost()
    end

    return cost
end

function Menu:PickGameType()
    return Utility.Random.PickOne(self.GameTypes)
end

function Menu:PickGameTheme()
    return Utility.Random.PickOne(self.GameThemes)
end

function Menu:Print()
    print("测试输出 类型开始：")
    for i = 1, self.GameTypes:Count() do
        local type  = self.GameTypes:Get(i)

        for j = 1, self.GameThemes:Count() do
            local theme     = self.GameThemes:Get(j)

            local fetter_id = Data.Fetter.FitterID(type, theme)

            if fetter_id == _C.FETTER.EXCELLENT then
                type.Price  = type.Price + 8000
                
            elseif fetter_id == _C.FETTER.GOOD then
                type.Price  = type.Price + 500

            elseif fetter_id == _C.FETTER.NORMAL then
                -- type.Price  = type.Price + 100

            end
        end

        print("测试输出 类型： " .. type.Name .. ", 价格：" .. type.Price)
    end

    print("测试输出 主题开始：")

    for i = 1, self.GameThemes:Count() do
        local theme  = self.GameThemes:Get(i)

        for j = 1, self.GameTypes:Count() do
            local type     = self.GameTypes:Get(j)

            local fetter_id = Data.Fetter.FitterID(type, theme)

            if fetter_id == _C.FETTER.EXCELLENT then
                theme.Price  = theme.Price + 2000
                
            elseif fetter_id == _C.FETTER.GOOD then
                theme.Price  = theme.Price + 500
            end
        end

        print("测试输出 主题： " .. theme.Name .. ", 价格：" .. theme.Price)
    end
end


function Menu:Update(deltaTime)
    self.CheckInterval:Update(deltaTime)
    if self.CheckInterval:IsFinished() == true then
        self.CheckInterval:Reset()
        
        --@region 类型、主题 解锁检测
        self.GameTypes:Each(function(game_type)
            if game_type:IsFinished() == false then
                if game_type:Check() == true then
                    game_type:Finish()
                    Controller.System.ShowNotice("解锁类型：" .. game_type.Name)
                end
            end     
        end)

        self.GameThemes:Each(function(game_theme)
            if game_theme:IsFinished() == false then
                if game_theme:Check() == true then
                    game_theme:Finish()
                    Controller.System.ShowNotice("解锁内容：" .. game_theme.Name)
                end
            end     
        end)
        --@endregion
    end

end

---------------------------reponse---------------------------
function Menu:OnGameBuildingEnd(event, game)
    self:InsertFetter(game.Fetter)
end

function Menu:OnGameReleaseStart(event, game)
    --@TODO 关注度衰减逻辑
    local type_id   = game.Type.ID
    local theme_id  = game.Theme.ID

    self.GameTypes:Each(function(game_type)
        if game_type.ID == type_id then
            game_type.Attention = game_type.Attention * 0.9
        else
            game_type.Attention = math.min(100, game_type.Attention / 0.8)
        end
    end)

    self.GameThemes:Each(function(game_theme)
        if game_theme.ID == theme_id then
            game_theme.Attention    = game_theme.Attention * 0.8
        else
            game_theme.Attention    = math.min(100, game_theme.Attention / 0.7)
        end
    end)

    if (game.Type:GetAttention() + game.Theme:GetAttention()) / 200.0 <= 0.7 then
        local description = string.format("发布过多相同类型或内容的游戏，会导致游戏的关注度下降，试试开发不同类型和内容的游戏吧~")
        LuaEventManager.SendEvent(_E.NEWS_PUSHREPORT, nil, {Times = Utility.Random.Range(1, 3), Desc = description})
    end
end

function Menu:OnStaffTrain(event, staff, train_flag)
    local params    = {Staff = staff, TrainFlag = train_flag}

    self.GameThemes:Each(function(game_theme)
        if game_theme:IsFinished() == false then
            if game_theme:Execute(params) == true then
                game_theme:Finish()
                Controller.System.ShowNotice("解锁内容：" .. game_theme.Name)
            end
        end     
    end)
end


return Menu