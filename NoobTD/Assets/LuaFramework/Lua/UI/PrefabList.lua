local PrefabList = {}

-- PrefabList[_C.UI.ITEM.HP]               = { Path = "Prefab/UI/Dungeon/MatHPBar"}

-- PrefabList[_C.UI.ITEM.TEST]             = { Path = "Prefab/UI/Item/TestItem" }
-- PrefabList[_C.UI.ITEM.STAFF]            = { Path = "Prefab/UI/Item/StaffItem"}
-- PrefabList[_C.UI.ITEM.GAME]             = { Path = "Prefab/UI/Item/GameItem"}
PrefabList[_C.UI.ITEM.SYSTEMTIP]        = { Path = "Prefab/UI/Item/SystemTipItem"}
PrefabList[_C.UI.ITEM.SYSTEMPOPUP]      = { Path = "Prefab/UI/Item/SystemPopupItem"}
PrefabList[_C.UI.ITEM.BUILD]            = { Path = "Prefab/UI/Item/BuildItem"}
-- PrefabList[_C.UI.ITEM.GAMETYPE]         = { Path = "Prefab/UI/Item/GameTypeItem"}
-- PrefabList[_C.UI.ITEM.GAMETHEME]        = { Path = "Prefab/UI/Item/GameThemeItem"}
-- PrefabList[_C.UI.ITEM.GAMECONSOLE]      = { Path = "Prefab/UI/Item/GameConsoleItem"}
-- PrefabList[_C.UI.ITEM.TRAIN]            = { Path = "Prefab/UI/Item/TrainItem"}
-- PrefabList[_C.UI.ITEM.JOB]              = { Path = "Prefab/UI/Item/JobItem"}
-- PrefabList[_C.UI.ITEM.GAMEATTRIBUTE]    = { Path = "Prefab/UI/Item/GameAttributeItem"}
-- PrefabList[_C.UI.ITEM.CE]               = { Path = "Prefab/UI/Item/CEItem"}
-- PrefabList[_C.UI.ITEM.SALEREPORT]       = { Path = "Prefab/UI/Item/SaleReportItem"}
-- PrefabList[_C.UI.ITEM.NETWORKREPORT]    = { Path = "Prefab/UI/Item/NetworkReportItem"}
-- PrefabList[_C.UI.ITEM.SELLCOUNT]        = { Path = "Prefab/UI/Item/SellCountItem"}
-- PrefabList[_C.UI.ITEM.MENU]             = { Path = "Prefab/UI/Item/MenuItem"}
-- PrefabList[_C.UI.ITEM.MENUOPTION]       = { Path = "Prefab/UI/Item/MenuOptionItem"}
-- PrefabList[_C.UI.ITEM.MONUMENT]         = { Path = "Prefab/UI/Item/MonumentItem"}
-- PrefabList[_C.UI.ITEM.ACHIVEMENT]       = { Path = "Prefab/UI/Item/AchivementItem"}
-- PrefabList[_C.UI.ITEM.GAMESCORELEFT]    = { Path = "Prefab/UI/Item/GameScoreLeftItem"}
-- PrefabList[_C.UI.ITEM.GAMESCORERIGHT]   = { Path = "Prefab/UI/Item/GameScoreRightItem"}
-- PrefabList[_C.UI.ITEM.ATTRIBUTE]        = { Path = "Prefab/UI/Item/AttributeItem"}
-- PrefabList[_C.UI.ITEM.NOTICE]           = { Path = "Prefab/UI/Item/NoticeItem"}
-- PrefabList[_C.UI.ITEM.POINT]            = { Path = "Prefab/UI/Item/PointItem"}
-- PrefabList[_C.UI.ITEM.GAMESCORE]        = { Path = "Prefab/UI/Item/GameScoreItem"}
-- PrefabList[_C.UI.ITEM.GAMESERIESTAB]    = { Path = "Prefab/UI/Item/GameSeriesTabItem"}
-- PrefabList[_C.UI.ITEM.GAMESERIES]       = { Path = "Prefab/UI/Item/GameSeriesItem"}
-- PrefabList[_C.UI.ITEM.JOBCENTRE]        = { Path = "Prefab/UI/Item/JobCentreItem"}
-- PrefabList[_C.UI.ITEM.CHARTNAME]        = { Path = "Prefab/UI/Item/ChartNameItem"}
-- PrefabList[_C.UI.ITEM.CHARTCIRCLE]      = { Path = "Prefab/UI/Item/ChartCircleItem"}
-- PrefabList[_C.UI.ITEM.STAFFLIGHT]       = { Path = "Prefab/UI/Item/StaffLightItem"}
-- PrefabList[_C.UI.ITEM.HARDWARE]         = { Path = "Prefab/UI/Item/HardwareItem"}
-- PrefabList[_C.UI.ITEM.CONSOLEELEMENT]   = { Path = "Prefab/UI/Item/ConsoleElementItem"}
-- PrefabList[_C.UI.ITEM.LOAN]             = { Path = "Prefab/UI/Item/LoanItem"}
-- PrefabList[_C.UI.ITEM.MESSAGE]          = { Path = "Prefab/UI/Item/MessageItem"}
-- PrefabList[_C.UI.ITEM.GAMEAGENT]        = { Path = "Prefab/UI/Item/GameAgentItem"}
-- PrefabList[_C.UI.ITEM.OUTSOURCE]        = { Path = "Prefab/UI/Item/OutsourceItem"}
-- PrefabList[_C.UI.ITEM.OUTSOURCEATTRIBUTE]   = { Path = "Prefab/UI/Item/OutsourceAttributeItem"}
-- PrefabList[_C.UI.ITEM.EXPBAR]           = { Path = "Prefab/UI/Item/ExpBarItem"}
-- PrefabList[_C.UI.ITEM.AGENTORBAR]       = { Path = "Prefab/UI/Item/AgentorBarItem"}







-- PrefabList[_C.UI.WINDOW.MAIN]           = { Class = UI.MainWindow,              Path = "Prefab/UI/Window/MainWindow",           Pause   = false}
-- PrefabList[_C.UI.WINDOW.GAMEREADY]      = { Class = UI.GameReadyWindow,         Path = "Prefab/UI/Window/GameReadyWindow",      Pause   = true }
-- PrefabList[_C.UI.WINDOW.GAMESCORE]      = { Class = UI.GameScoreWindow,         Path = "Prefab/UI/Window/GameScoreWindow",      Pause   = true }
PrefabList[_C.UI.WINDOW.SYSTEMPOPUP]    = { Class = UI.SystemPopupWindow,       Path = "Prefab/UI/Window/SystemPopupWindow"}
PrefabList[_C.UI.WINDOW.BATTLE]         = { Class = UI.BattleWindow,            Path = "Prefab/UI/Window/BattleWindow"}

-- PrefabList[_C.UI.WINDOW.GAMEREADY]      = { Class = UI.GameReadyWindow,         Path = "Prefab/UI/Window/GameReadyWindow",      Pause   = true }
-- PrefabList[_C.UI.WINDOW.GAMESCORE]      = { Class = UI.GameScoreWindow,         Path = "Prefab/UI/Window/GameScoreWindow",      Pause   = true }
-- PrefabList[_C.UI.WINDOW.GAMETYPE]       = { Class = UI.GameTypeWindow,          Path = "Prefab/UI/Window/GameTypeWindow",       Pause   = true }
-- PrefabList[_C.UI.WINDOW.GAMETHEME]      = { Class = UI.GameThemeWindow,         Path = "Prefab/UI/Window/GameThemeWindow",      Pause   = true }
-- PrefabList[_C.UI.WINDOW.GAMECONSOLE]    = { Class = UI.GameConsoleWindow,       Path = "Prefab/UI/Window/GameConsoleWindow",    Pause   = true }
-- PrefabList[_C.UI.WINDOW.GAMEMAIN]       = { Class = UI.GameMainWindow,          Path = "Prefab/UI/Window/GameMainWindow",       Pause   = true }
-- PrefabList[_C.UI.WINDOW.JOBCENTRE]      = { Class = UI.JobCentreWindow,         Path = "Prefab/UI/Window/JobCentreWindow",      Pause   = true }
-- PrefabList[_C.UI.WINDOW.PLAN]           = { Class = UI.PlanWindow,              Path = "Prefab/UI/Window/PlanWindow",           Pause   = true }
-- PrefabList[_C.UI.WINDOW.ART]            = { Class = UI.ArtWindow,               Path = "Prefab/UI/Window/ArtWindow",            Pause   = true }
-- PrefabList[_C.UI.WINDOW.SCHOOL]         = { Class = UI.SchoolWindow,            Path = "Prefab/UI/Window/SchoolWindow",         Pause   = true }
-- PrefabList[_C.UI.WINDOW.JOBUPGRADE]     = { Class = UI.JobUpgradeWindow,        Path = "Prefab/UI/Window/JobUpgradeWindow",     Pause   = true }
-- PrefabList[_C.UI.WINDOW.MENU]           = { Class = UI.MenuWindow,              Path = "Prefab/UI/Window/MenuWindow",           Pause   = true }
-- PrefabList[_C.UI.WINDOW.MONUMENT]       = { Class = UI.MonumentWindow,          Path = "Prefab/UI/Window/MonumentWindow",       Pause   = true }
-- PrefabList[_C.UI.WINDOW.STAFFMAIN]      = { Class = UI.StaffMainWindow,         Path = "Prefab/UI/Window/StaffMainWindow",      Pause   = true }
-- PrefabList[_C.UI.WINDOW.GM]             = { Class = UI.GMWindow,                Path = "Prefab/UI/Window/GMWindow",             Pause   = true }
-- PrefabList[_C.UI.WINDOW.PROPAGANDA]     = { Class = UI.PropagandaWindow,        Path = "Prefab/UI/Window/PropagandaWindow",     Pause   = true }
-- PrefabList[_C.UI.WINDOW.GAMESEQUEL]     = { Class = UI.GameSequelWindow,        Path = "Prefab/UI/Window/GameSequelWindow",     Pause   = true }
-- PrefabList[_C.UI.WINDOW.SEQUELMAIN]     = { Class = UI.SequelMainWindow,        Path = "Prefab/UI/Window/SequelMainWindow",     Pause   = true }
-- PrefabList[_C.UI.WINDOW.GAMESERIES]     = { Class = UI.GameSeriesWindow,        Path = "Prefab/UI/Window/GameSeriesWindow",     Pause   = true }
-- PrefabList[_C.UI.WINDOW.JOBCENTRELIST]  = { Class = UI.JobCentreListWindow,     Path = "Prefab/UI/Window/JobCentreListWindow",  Pause   = true }
-- PrefabList[_C.UI.WINDOW.GAMETOPTEN]     = { Class = UI.GameTopTenWindow,        Path = "Prefab/UI/Window/GameTopTenWindow",     Pause   = true }
-- PrefabList[_C.UI.WINDOW.CONSOLEMAIN]    = { Class = UI.ConsoleMainWindow,       Path = "Prefab/UI/Window/ConsoleMainWindow",    Pause   = true }
-- PrefabList[_C.UI.WINDOW.CONSOLEREADY]   = { Class = UI.ConsoleReadyWindow,      Path = "Prefab/UI/Window/ConsoleReadyWindow",   Pause   = true }
-- PrefabList[_C.UI.WINDOW.CONSOLEELEMENT] = { Class = UI.ConsoleElementWindow,    Path = "Prefab/UI/Window/ConsoleElementWindow", Pause   = true }
-- PrefabList[_C.UI.WINDOW.BANK]           = { Class = UI.BankWindow,              Path = "Prefab/UI/Window/BankWindow",           Pause   = true }
-- PrefabList[_C.UI.WINDOW.GAMELIST]       = { Class = UI.GameListWindow,          Path = "Prefab/UI/Window/GameListWindow",       Pause   = true }
-- PrefabList[_C.UI.WINDOW.FACTORY]        = { Class = UI.FactoryWindow,           Path = "Prefab/UI/Window/FactoryWindow",        Pause   = true }
-- PrefabList[_C.UI.WINDOW.ADVERT]         = { Class = UI.AdvertWindow,            Path = "Prefab/UI/Window/AdvertWindow",         Pause   = true }
-- PrefabList[_C.UI.WINDOW.FACTORYPAUSE]   = { Class = UI.FactoryPauseWindow,      Path = "Prefab/UI/Window/FactoryPauseWindow",   Pause   = true }
-- PrefabList[_C.UI.WINDOW.AGENT]          = { Class = UI.AgentWindow,             Path = "Prefab/UI/Window/AgentWindow",          Pause   = true }
-- PrefabList[_C.UI.WINDOW.OUTSOURCE]      = { Class = UI.OutsourceWindow,         Path = "Prefab/UI/Window/OutsourceWindow",      Pause   = true }
-- PrefabList[_C.UI.WINDOW.LOGIN]          = { Class = UI.LoginWindow,             Path = "Prefab/UI/Window/LoginWindow",          Pause   = true }
-- PrefabList[_C.UI.WINDOW.LOADING]        = { Class = UI.LoadingWindow,           Path = "Prefab/UI/Window/LoadingWindow",        Pause   = true }
-- PrefabList[_C.UI.WINDOW.REGISTER]       = { Class = UI.RegisterWindow,          Path = "Prefab/UI/Window/RegisterWindow",       Pause   = true }
-- PrefabList[_C.UI.WINDOW.REGISTERCOMPANY]= { Class = UI.RegisterCompanyWindow,   Path = "Prefab/UI/Window/RegisterCompanyWindow",Pause   = true }
-- PrefabList[_C.UI.WINDOW.AGENTORRESULT]  = { Class = UI.AgentorResultWindow,     Path = "Prefab/UI/Window/AgentorResultWindow",  Pause   = true }
-- PrefabList[_C.UI.WINDOW.SIDELINE]       = { Class = UI.SidelineWindow,          Path = "Prefab/UI/Window/SidelineWindow",       Pause   = false }
-- PrefabList[_C.UI.WINDOW.FACTORYRESULT]  = { Class = UI.FactoryResultWindow,     Path = "Prefab/UI/Window/FactoryResultWindow",  Pause   = true }








return PrefabList