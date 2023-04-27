
--导航

local Navigation    = {}

--菜单界面
function Navigation.GotoMenu()
    UI.Manager:LoadUIWindow(_C.UI.WINDOW.MENU, UI.Manager.MAJOR)
    UI.MenuWindow.Init()
end




return Navigation