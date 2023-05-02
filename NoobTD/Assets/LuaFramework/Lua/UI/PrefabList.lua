local PrefabList = {}


PrefabList[_C.UI.ITEM.SYSTEMTIP]        = { Path = "Prefab/UI/Item/SystemTipItem"}
PrefabList[_C.UI.ITEM.SYSTEMPOPUP]      = { Path = "Prefab/UI/Item/SystemPopupItem"}
PrefabList[_C.UI.ITEM.BUILD]            = { Path = "Prefab/UI/Item/BuildItem"}
PrefabList[_C.UI.ITEM.HPBAR]            = { Path = "Prefab/UI/Item/HPBar"}






-- PrefabList[_C.UI.WINDOW.MAIN]           = { Class = UI.MainWindow,              Path = "Prefab/UI/Window/MainWindow",           Pause   = false}

PrefabList[_C.UI.WINDOW.SYSTEMPOPUP]    = { Class = UI.SystemPopupWindow,       Path = "Prefab/UI/Window/SystemPopupWindow"}
PrefabList[_C.UI.WINDOW.BATTLE]         = { Class = UI.BattleWindow,            Path = "Prefab/UI/Window/BattleWindow"}







return PrefabList