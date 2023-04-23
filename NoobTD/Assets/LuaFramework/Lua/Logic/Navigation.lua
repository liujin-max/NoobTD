
--导航

local Navigation    = {}

--菜单界面
function Navigation.GotoMenu()
    UI.Manager:LoadUIWindow(_C.UI.WINDOW.MENU, UI.Manager.MAJOR)
    UI.MenuWindow.Init()
end

--新游制作界面
function Navigation.GotoNewGame()
    Controller.Game.Start()
end

--主机制作界面
function Navigation.GotoNewConsole()
    Controller.Console.Start()
end

--续作制作界面
function Navigation.GotoSequelGame()
    Controller.GameSequel.Start()
end

--员工信息界面
function Navigation.GotoStaffInfo()
    Controller.Staff.Start()
end

--员工招聘界面
function Navigation.GotoHR()
    Controller.HR.Start()
end

--宣传界面
function Navigation.GotoAdvert()
    Controller.Propaganda.Start()
end

--银行界面
function Navigation.GotoBank()
    Controller.Bank.Start()
end

--排行界面
function Navigation.GotoMonument()
    -- UI.Manager:LoadUIWindow(_C.UI.WINDOW.MONUMENT, UI.Manager.BORAD)
    -- UI.MonumentWindow.Init()

    UI.Manager:LoadUIWindow(_C.UI.WINDOW.GAMETOPTEN, UI.Manager.BORAD)
    UI.GameTopTenWindow.Init()
end

--游戏系列
function Navigation.GotoGameSeries()
    Controller.GameSeries.Start()
end

--游戏列表
function Navigation.GotoGameList()
    UI.Manager:LoadUIWindow(_C.UI.WINDOW.GAMELIST, UI.Manager.MAJOR_ABOVE)
    UI.GameListWindow.Init()
end

--外包列表
function Navigation.GotoOutsource()
    Controller.Outsource.Start()
end

--发行商列表
function Navigation.GotoAgentor()
    UI.Manager:LoadUIWindow(_C.UI.WINDOW.AGENT, UI.Manager.MAJOR)
    UI.AgentWindow.Init(Controller.Data.Agentor():GetAgents(), true)
end


return Navigation