--RecordController: 

--1. 游戏开始时, 加载进度文件至游戏中, 利用CJSON, 转化为luaTable, 以备其他模块访问

--2. 当前没有网络同步，当其他模块请求数据时，本质上走到这里，根据接口，传递相应的luatable数据过去

--3. 当写入时, 只是通过这里的接口, 修改对应的luatable, 然后再用cjson转化为json, 写入文件中

--4. 当前所有进度数据，组织到一个大的Progress文件中就行


local json = require "cjson"
local util = require "cjson.util"

RecordController = {}

local InitPath  = "GameData/GameProgress"
local StorePath = UnityEngine.Application.persistentDataPath .. "/record/GameProgress.json"
local DirPath   = UnityEngine.Application.persistentDataPath .. "/record/"
local data      = nil

local is_dirty  = false


local function Load()
    print("测试输出 存档地址：" .. DirPath)
    if FileUtility.IsDirectoryExist(DirPath) == false then
        FileUtility.CreateDirectory(DirPath)
    end

    local json_text = nil
    if AssetManager:FileExist(StorePath) == true and ConstManager.Reboot == false then
        json_text = util.file_load(StorePath)
    else
        json_text = AssetManager:LoadText(InitPath)
        AssetManager:CreateTextFile(StorePath, json_text)
    end

    data = json.decode(json_text)
end


local function Save()
    local json_text = json.encode(data)
    util.file_save(StorePath, json_text)
end

function RecordController.Clear()
    local json_text = AssetManager:LoadText(InitPath)
    AssetManager:CreateTextFile(StorePath, json_text)

    Load()
end

function RecordController.Update()
    --print("<============ RecordController.Update =========>")
    if is_dirty == true then
        Save()
        is_dirty = false
    end
end

function RecordController.HasRecord()
    return data.Account ~= nil
end

function RecordController.GetData()
    return data
end

function RecordController.ForceSave()
    Save()
end

--读取文件路径路径, 利用CJSON转化
function RecordController.Awake(path)
    Load()
end 


--@region Date
function RecordController.GetDate()
    return data.Date or {}
end

function RecordController.SaveDate()
    local date      = Controller.Data.Date()

    data.Date       = {}
    data.Date.Date  = date:GetDate()

    data.Date.Year  = date:GetYear():GetCurrent()
    data.Date.Month = date:GetMonth():GetCurrent()
    data.Date.Week  = date:GetWeek():GetCurrent()
    data.Date.Day   = date:GetDay():GetCurrent()
end

--@endregion




--@region 菜单
function RecordController.GetMenus()
    return data.Menus or {}
end

function RecordController.SaveMenus()
    local menu_data     = Controller.Data.Menu()

    if data.Menus == nil then
        data.Menus      = {}
    end


    data.Menus.GameTypes    = {}
    data.Menus.GameThemes   = {}
    data.Menus.GameConsoles = {}
    data.Menus.FetterDic    = {}


    local game_types    = menu_data:GetGameTypes()
    game_types:Each(function(type)
        if type:IsFinished() == true then
            table.insert(data.Menus.GameTypes,  {ID = type.ID, Attention = type.Attention, Level = type.Level, Exp = type.Exp })
        end        
    end)

    local game_themes   = menu_data:GetGameThemes()
    game_themes:Each(function(theme)
        if theme:IsFinished() == true then
            table.insert(data.Menus.GameThemes,  {ID = theme.ID, Attention = theme.Attention, Level = theme.Level, Exp = theme.Exp})
        end        
    end)

    local game_consoles = menu_data:GetGameConsoles()
    game_consoles:Each(function(console)
        table.insert(data.Menus.GameConsoles,  console:ExportTable())
    end)


    local fetter_dic    = menu_data.FetterDic
    for type_id, temp in pairs(fetter_dic) do
        for theme_id,v in pairs(temp) do
            table.insert(data.Menus.FetterDic,  {Type = type_id, Theme = theme_id})
        end
    end

end
--@endregion



--@region Account
function RecordController.GetAccount()
    return data.Account or {}
end

function RecordController.SaveAccount()
    local account   = Controller.Data.Account()
    local company   = account:GetCompany()
    local staffs    = company:GetStaffs()
    local history   = account.History

    local companys  = account:GetCompanys()

    data.Account    = {
        MyCompany   = 
        {
            ID      = company.ID,
            Money   = company.Money,
            Research= company.Research,
            Name    = company.Name,
        },

        Bill            = account.Bill,
        OJob            = account.OJob,
        RegisterState   = account.RegisterState,
        FreeDice        = account.FreeDice
    }

    data.Account.MyCompany.Staffs   = {}
    for i = 1, staffs:Count() do
        local stf   = staffs:Get(i)
        table.insert(data.Account.MyCompany.Staffs, stf:Export())
    end

    data.Account.Companys   = {}
    for i = 1, companys:Count() do
        local c = companys:Get(i)
        if c:IsUnlock() == true then
            table.insert(data.Account.Companys, {ID = c.ID})
        end
    end


    data.Account.History            = {}
    data.Account.History.Games      = {}
    data.Account.History.Scores     = {}
    data.Account.History.SequelCum  = history.SequelCum
    data.Account.History.ScoreGame  = history.ScoreGame ~= nil and history.ScoreGame.Order or -1
    data.Account.History.SequelGames= {}
    data.Account.History.Consoles   = {}
    data.Account.History.BuildTypes = {}
    data.Account.History.Incomes    = {}

    for i = 1, history.Games:Count() do
        local game  = history.Games:Get(i)
        local temp  = game:ExportGameData()

        table.insert(data.Account.History.Games, temp)
    end

    for k,v in pairs(history.Scores) do
        table.insert(data.Account.History.Scores, {ID = k, Value = v})
    end

    for i = 1, history.SequelGames:Count() do
        local game  = history.SequelGames:Get(i)
        table.insert(data.Account.History.SequelGames, {Order   = game.Order})
    end

    for i = 1, history.Consoles:Count() do
        local console   = history.Consoles:Get(i)
        local console_table      = console:ExportTable(true)
        table.insert(data.Account.History.Consoles, console_table)
    end

    for type_id, count in ipairs(history.BuildTypes) do
        table.insert(data.Account.History.BuildTypes, {ID = type_id, Count = count})
    end

    for year, value in ipairs(history.Incomes) do
        table.insert(data.Account.History.Incomes, {ID = year, Value = value})
    end
end

--@endregion



--@region Fans
function RecordController.GetFans()
    return data.Fans or {}
end

function RecordController.SaveFans()
    local fans  = Controller.Data.Fans()

    data.Fans   = {}

    local fans_counts   = fans.Counts
    data.Fans.Counts    = fans_counts
end

--@endregion


--@region GameMarket
function RecordController.GetGameMarket()
    return data.GameMarket or {}
end

function RecordController.SaveGameMarket()
    local market    = Controller.Data.GameMarket()

    data.GameMarket = {}
    data.GameMarket.PeopleCount = market:GetPeopleMax()

    local consoles  = market:GetConsoles()
    data.GameMarket.Consoles    = {}
    consoles:Each(function(console)
        table.insert(data.GameMarket.Consoles, {ID = console.ID})
    end)

end

--@endregion



--@region 成就
function RecordController.GetAchievement()
    return data.Achievement or {}
end

function RecordController.SaveAchievement()
    local achivement    = Controller.Data.Achievement()

    data.Achievement    = {}

    local tasks         = achivement:GetTasks()
    data.Achievement.Tasks  = {}
    tasks:Each(function(t)
        if t:IsFinished() == true then
            table.insert(data.Achievement.Tasks, {ID = t.ID})
        end
    end)
end

--@endregion


--@region Functions
function RecordController.GetFunctions()
    return data.FunctionData or {}
end

function RecordController.SaveFunctions()
    local function_mgr  = Controller.Data.FunctionMgr()

    data.FunctionData   = {}

    local functions     = function_mgr:GetDatas()
    data.FunctionData.Datas     = {}
    functions:Each(function(f)
        if f:IsFinished() == true then
            table.insert(data.FunctionData.Datas, {ID = f.ID})
        end        
    end)
end

--@endregion


--@region Factory
function RecordController.GetFactory()
    return data.Factory or {}
end

function RecordController.SaveFactory()
    local factory   = Controller.Data.Factory()

    data.Factory    = 
    {
        TimeCD      = {Value = factory.TimeCD:GetCurrent(), Total = factory.TimeCD:GetTotal()}
    }

    data.Factory.TimeMax    = {}

    for k, value in pairs(factory.TimeMax) do
        table.insert(data.Factory.TimeMax, {ID = k, Value = value})
    end

    local game      = factory:GetActingGame()
    if game ~= nil then
        local game_table        = game:ExportGameData()
        data.Factory.ActingGame = game_table
    end

    -- if factory.OrbControl ~= nil then
    --     data.Factory.OrbControl = factory.OrbControl:ExportTable()
    -- end
end

--@endregion

--@region Agentor
function RecordController.GetAgentor()
    return data.Agentor or {}
end

function RecordController.SaveAgentor()
    local agentor  = Controller.Data.Agentor()

    data.Agentor   = {}
    data.Agentor.CDTimer = {Value = agentor.CDTimer:GetCurrent(), Total = agentor.CDTimer:GetTotal()}
    if agentor.ActingGame ~= nil then
        data.Agentor.Game   = 
        {
            Order   = agentor.ActingGame.Order,
        }    
    end

    data.Agentor.Agents = {}
    local agents        = agentor.Agents
    for i = 1, agents:Count() do
        local agent     = agents:Get(i)
        table.insert(data.Agentor.Agents, {ID = agent.ID, Exp = agent.Exp})
    end
     
end
--@endregion

--@region Releaser
function RecordController.GetReleaser()
    return data.Releaser or {}
end

function RecordController.SaveReleaser()
    local releaser  = Controller.Data.Releaser()

    data.Releaser   = {}
    data.Releaser.Publishers    = {}

    local publisher_array   = releaser:GetPublishers()

    publisher_array:Each(function(publisher)
        local game  = publisher:GetActingGame()

        table.insert(data.Releaser.Publishers, {Order = game.Order})
    end)
end

--@endregion

--@region Propaganda
function RecordController.GetPropaganda()
    return data.Propaganda or {}
end

function RecordController.SavePropaganda()
    local propaganda    = Controller.Data.Propaganda()

    data.Propaganda     = 
    {
        Budget          = propaganda.Budget
    }

    data.Propaganda.Adverts = {}
    local advert_array  = propaganda:GetAdverts()
    for i = 1, advert_array:Count() do
        local advert    = advert_array:Get(i)
        if advert:IsUnlock() == true then
            table.insert(data.Propaganda.Adverts, {ID = advert.ID})
        end
    end
end

--@endregion

--@region HR
function RecordController.GetHR()
    return data.HR or {}
end

function RecordController.SaveHR()
    local hr    = Controller.Data.HR()

    data.HR                 = {}
    data.HR.JobCentres      = {}
    data.HR.CurrentCentre   = hr:InProgress() and hr.CurrentCentre.ID or nil

    local job_centres   = hr:GetJobCentres()
    for i = 1, job_centres:Count() do
        local centre    = job_centres:Get(i)

        if centre:IsUnlock() == true then
            table.insert(data.HR.JobCentres, centre:Export()) 
        end
    end
end

--@endregion

--@region Foundry
function RecordController.GetFoundry()
    return data.Foundry or {}
end

function RecordController.SaveFoundry()
    local foundry   = Controller.Data.Foundry()

    data.Foundry    = 
    {
        TimeCD      = {Value = foundry.TimeCD:GetCurrent(), Total = foundry.TimeCD:GetTotal()}
    }

    local hardware  = foundry:GetHardware()
    if hardware ~= nil then
        data.Foundry.Hardware   = hardware:ExportTable()
    end

end

--@endregion

--@region ConsoleSeller
function RecordController.GetConsoleSeller()
    return data.ConsoleSeller or {}
end

function RecordController.SaveConsoleSeller()
    local seller    = Controller.Data.ConsoleSeller()
    
    data.ConsoleSeller  = {}
    data.ConsoleSeller.Process  = seller.Process

    local console   = seller:GetActingConsole()
    if console ~= nil then
        data.ConsoleSeller.ActingConsole   = console.ID
    end
end

--@endregion

--@region Bank
function RecordController.GetBank()
    return data.Bank or {}
end

function RecordController.SaveBank()
    local bank  = Controller.Data.Bank()

    data.Bank   = {}

    data.Bank.SignLoans = {}
    local sign_loans     = bank:GetSignLoans()
    for i = 1, sign_loans:Count() do
        local loan  = sign_loans:Get(i)
        table.insert(data.Bank.SignLoans, 
        {
            ID      = loan.ID, 
            TimeCD  = {Value = loan.TimeCD:GetCurrent(), Total = loan.TimeCD:GetTotal(),
        }})
    end
end

--@endregion

--@region School
function RecordController.GetSchool()
    return data.School or {}
end

function RecordController.SaveSchool()
    local school    = Controller.Data.School()

    data.School     = {}
    data.School.Trains  = {}

    local trains    = school:GetTrains()
    trains:Each(function(train_flag, idx)
        if train_flag:IsUnlock() == true then
            table.insert(data.School.Trains, {ID = train_flag.ID , TrainCount = train_flag.TrainCount})
        end
    end)
end

--@endregion


--@region News
function RecordController.GetNews()
    return data.News or {}
end

function RecordController.SaveNews()
    local news  = Controller.Data.News()

    data.News   = {}
    data.News.Reports   = {}

    local reports = news:GetReports()
    for i = 1, reports:Count() do
        local report    = reports:Get(i)

        table.insert(data.News.Reports, {Description = report.Description ,Timer = {Value = report.Timer:GetCurrent(), Total = report.Timer:GetTotal()}})
    end
end
--@endregion

--@region Farm
function RecordController.GetFarm()
    return data.Farm or {}
end

function RecordController.SaveFarm()
    local farm  = Controller.Data.Farm()

    data.Farm   = {}
    data.Farm.Waiting   = {Value = farm.Waiting:GetCurrent() , Total = farm.Waiting:GetTotal()}
    if farm.ActingOutsource ~= nil then
        data.Farm.ActingOutsource   = farm.ActingOutsource:Export()
    end

    data.Farm.Actives   = {}
    for i = 1, farm.Actives:Count() do
        local source    = farm.Actives:Get(i)
        table.insert(data.Farm.Actives, source:Export())
    end
end

--@endregion


--@region Sideline
function RecordController.GetSideline()
    return data.Sideline or {}
end

function RecordController.SaveSideline()
    local sideline  = Controller.Data.Sideline()

    data.Sideline   = {}
    data.Sideline   = sideline:Export()
end
--@endregion











function RecordController.ImmediateSave()
    RecordController.SaveDate()
    RecordController.SaveMenus()
    RecordController.SaveAccount()
    RecordController.SaveFans()

    RecordController.SaveFactory()
    RecordController.SaveAgentor()
    RecordController.SaveReleaser()
    RecordController.SaveFoundry()
    RecordController.SaveConsoleSeller()
    RecordController.SaveFarm()
    RecordController.SaveSideline()

    RecordController.SaveGameMarket()
    RecordController.SaveAchievement()
    RecordController.SaveFunctions()
    RecordController.SavePropaganda()
    RecordController.SaveSchool()
    RecordController.SaveBank()
    RecordController.SaveNews()


    RecordController.SaveHR()

    print("===== RecordController.ImmediateSave =====")
    
    Save()
end

function RecordController.GetGameConsole()
    return data.GameConsole or -1
end

function RecordController.SetGameConsole(id)
    data.GameConsole    = id    
end

function RecordController.GetGameType()
    return data.GameType or -1
end

function RecordController.SetGameType(id)
    data.GameType    = id  
end

function RecordController.GetGameTheme()
    return data.GameTheme or -1
end

function RecordController.SetGameTheme(id)
    data.GameTheme      = id 
end
