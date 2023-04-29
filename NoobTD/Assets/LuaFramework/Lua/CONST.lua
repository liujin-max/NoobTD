_C = {}




_C.CONST                = {}
_C.CONST.WEEKSECOND     = 7         --7秒一周



--战场数据
_C.CONST.LAND           = {}
_C.CONST.LAND.WIDTH     = 20        --战场宽度
_C.CONST.LAND.HEIGHT    = 11        --战场高度

_C.CONST.LAND.GRID      = 50        --格子尺寸


--场景
_C.SCENE_LAYER          = {}
_C.SCENE_LAYER.MAIN     = "main"
_C.SCENE_LAYER.BATTLE   = "Battle"


--@region 战斗
_C.BATTLE               = {}
--战斗结果
_C.BATTLE.RESULT        = {}
_C.BATTLE.RESULT.WIN    = "RESULT.WIN"      
_C.BATTLE.RESULT.LOSE   = "RESULT.LOSE"
--@endregion

_C.SIDE                 = {}
_C.SIDE.ATTACK          = 1     --进攻方
_C.SIDE.DEFEND          = 2     --防守方




--行为动作
_C.ACTION               = {}
_C.ACTION.VOID          = "ACTION.VOID"
_C.ACTION.WALK          = "ACTION.WALK"     --行走
_C.ACTION.IDLE          = "ACTION.IDLE"     --待机
_C.ACTION.CAST          = "ACTION.CAST"     --施法
_C.ACTION.DEAD          = "ACTION.DEAD"     --死亡
_C.ACTION.BORN          = "ACTION.BORN"     --诞生、绘制
_C.ACTION.REACH         = "ACTION.REACH"    --到达终点


--死亡原因
_C.DEAD                 = {}
_C.DEAD.NORMAL          = "DEAD.NORMAL"     --正常击杀死亡





_C.HIT                  = {}
--打击类型
_C.HIT.TYPE             = {}
_C.HIT.TYPE.ATK         = "HIT.TYPE.ATK"
_C.HIT.TYPE.HEAL        = "HIT.TYPE.HEAL"
_C.HIT.TYPE.ARMOR       = "HIT.TYPE.ARMOR"


------------------------- UI的相关变量 -------------------
_C.UI                       = {}
_C.UI.ITEM                  = {}
-- _C.UI.ITEM.TEST             = "TestItem"
-- _C.UI.ITEM.HP               = "HPBar"
-- _C.UI.ITEM.STAFF            = "StaffItem"
-- _C.UI.ITEM.GAME             = "GameItem"
_C.UI.ITEM.SYSTEMTIP        = "SystemTipItem"
_C.UI.ITEM.SYSTEMPOPUP      = "SystemPopupItem"
-- _C.UI.ITEM.GAMETYPE         = "GameTypeItem"
-- _C.UI.ITEM.GAMETHEME        = "GameThemeItem"
-- _C.UI.ITEM.GAMECONSOLE      = "GameConsoleItem"
-- _C.UI.ITEM.TRAIN            = "TrainItem"
-- _C.UI.ITEM.JOB              = "JobItem"
-- _C.UI.ITEM.GAMEATTRIBUTE    = "GameAttributeItem"
-- _C.UI.ITEM.CE               = "CEItem"
-- _C.UI.ITEM.SALEREPORT       = "SaleReportItem"
-- _C.UI.ITEM.NETWORKREPORT    = "NetworkReportItem"
-- _C.UI.ITEM.SELLCOUNT        = "SellCountItem"
-- _C.UI.ITEM.MENU             = "MenuItem"
-- _C.UI.ITEM.MENUOPTION       = "MenuOptionItem"
-- _C.UI.ITEM.MONUMENT         = "MonumentItem"
-- _C.UI.ITEM.ACHIVEMENT       = "AchivementItem"
-- _C.UI.ITEM.GAMESCORELEFT    = "GameScoreLeftItem"
-- _C.UI.ITEM.GAMESCORERIGHT   = "GameScoreRightItem"
-- _C.UI.ITEM.ATTRIBUTE        = "AttributeItem"
-- _C.UI.ITEM.NOTICE           = "NoticeItem"
-- _C.UI.ITEM.POINT            = "PointItem"
-- _C.UI.ITEM.GAMESCORE        = "GameScoreItem"
-- _C.UI.ITEM.GAMESERIESTAB    = "GameSeriesTabItem"
-- _C.UI.ITEM.GAMESERIES       = "GameSeriesItem"
-- _C.UI.ITEM.JOBCENTRE        = "JobCentreItem"
-- _C.UI.ITEM.CHARTCIRCLE      = "ChartCircleItem"
-- _C.UI.ITEM.CHARTNAME        = "ChartNameItem"
-- _C.UI.ITEM.STAFFLIGHT       = "StaffLightItem"
-- _C.UI.ITEM.HARDWARE         = "HardwareItem"
-- _C.UI.ITEM.CONSOLEELEMENT   = "ConsoleElementItem"
-- _C.UI.ITEM.LOAN             = "LoanItem"
-- _C.UI.ITEM.MESSAGE          = "MessageItem"
-- _C.UI.ITEM.GAMEAGENT        = "GameAgentItem"
-- _C.UI.ITEM.OUTSOURCE        = "OutsourceItem"
-- _C.UI.ITEM.OUTSOURCEATTRIBUTE   = "OutsourceAttributeItem"
-- _C.UI.ITEM.EXPBAR           = "ExpBarItem"
-- _C.UI.ITEM.AGENTORBAR       = "AgentorBarItem"





_C.UI.WINDOW                = {}
-- _C.UI.WINDOW.MAIN           = "MainWindow"
-- _C.UI.WINDOW.GAMEREADY      = "GameReadyWindow"
-- _C.UI.WINDOW.GAMESCORE      = "GameScoreWindow"
_C.UI.WINDOW.SYSTEMPOPUP    = "SystemPopupWindow"
-- _C.UI.WINDOW.GAMETYPE       = "GameTypeWindow"
-- _C.UI.WINDOW.GAMETHEME      = "GameThemeWindow"
-- _C.UI.WINDOW.GAMECONSOLE    = "GameConsoleWindow"
-- _C.UI.WINDOW.GAMEMAIN       = "GameMainWindow"
-- _C.UI.WINDOW.JOBCENTRE      = "JobCentreWindow"
-- _C.UI.WINDOW.PLAN           = "PlanWindow"
-- _C.UI.WINDOW.ART            = "ArtWindow"
-- _C.UI.WINDOW.SCHOOL         = "SchoolWindow"
-- _C.UI.WINDOW.JOBUPGRADE     = "JobUpgradeWindow"
-- _C.UI.WINDOW.MENU           = "MenuWindow"
-- _C.UI.WINDOW.MONUMENT       = "MonumentWindow"
-- _C.UI.WINDOW.STAFFMAIN      = "StaffMainWindow"
-- _C.UI.WINDOW.GM             = "GMWindow"
-- _C.UI.WINDOW.PROPAGANDA     = "PropagandaWindow"
-- _C.UI.WINDOW.GAMESEQUEL     = "GameSequelWindow"
-- _C.UI.WINDOW.SEQUELMAIN     = "SequelMainWindow"
-- _C.UI.WINDOW.GAMESERIES     = "GameSeriesWindow"
-- _C.UI.WINDOW.JOBCENTRELIST  = "JobCentreListWindow"
-- _C.UI.WINDOW.GAMETOPTEN     = "GameTopTenWindow"
-- _C.UI.WINDOW.CONSOLEMAIN    = "ConsoleMainWindow"
-- _C.UI.WINDOW.CONSOLEREADY   = "ConsoleReadyWindow"
-- _C.UI.WINDOW.CONSOLEELEMENT = "ConsoleElementWindow"
-- _C.UI.WINDOW.BANK           = "BankWindow"
-- _C.UI.WINDOW.GAMELIST       = "GameListWindow"
-- _C.UI.WINDOW.FACTORY        = "FactoryWindow"
-- _C.UI.WINDOW.ADVERT         = "AdvertWindow"
-- _C.UI.WINDOW.FACTORYPAUSE   = "FactoryPauseWindow"
-- _C.UI.WINDOW.AGENT          = "AgentWindow"
-- _C.UI.WINDOW.OUTSOURCE      = "OutsourceWindow"
-- _C.UI.WINDOW.LOGIN          = "LoginWindow"
-- _C.UI.WINDOW.LOADING        = "LoadingWindow"
-- _C.UI.WINDOW.REGISTER       = "RegisterWindow"
-- _C.UI.WINDOW.REGISTERCOMPANY    = "RegisterCompanyWindow"
-- _C.UI.WINDOW.AGENTORRESULT  = "AgentorResultWindow"
-- _C.UI.WINDOW.SIDELINE       = "SidelineWindow"
-- _C.UI.WINDOW.FACTORYRESULT  = "FactoryResultWindow"







_C.MESSAGE          = {}

_C.EVENT                    = {}
_C.EVENT.TRIGGER            = {}
_C.EVENT.TRIGGER.CHECK      = "EVENT.TRIGGER.CHECK"
_C.EVENT.TRIGGER.EXECUTE    = "EVENT.TRIGGER.EXECUTE"
_C.EVENT.TRIGGER.EXECUTABLE = "EVENT.TRIGGER.EXECUTABLE"
_C.EVENT.TRIGGER.DESCRIPTION= "EVENT.TRIGGER.DESCRIPTION"

-----
_C.PHASE                    = {}
_C.PHASE.ONEXECUTE          = "PHASE.ONEXECUTE"         --执行
