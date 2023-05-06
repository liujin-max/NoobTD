local PrefabList = {}


PrefabList[_C.UI.ITEM.SYSTEMTIP]        = { Path = "Prefab/UI/Item/SystemTipItem"}
PrefabList[_C.UI.ITEM.SYSTEMPOPUP]      = { Path = "Prefab/UI/Item/SystemPopupItem"}
PrefabList[_C.UI.ITEM.BUILD]            = { Path = "Prefab/UI/Item/BuildItem"}
PrefabList[_C.UI.ITEM.HPBAR]            = { Path = "Prefab/UI/Item/HPBar"}
PrefabList[_C.UI.ITEM.BUILDRING]        = { Path = "Prefab/UI/Item/BuildRingItem"}
PrefabList[_C.UI.ITEM.WAVETAG]          = { Path = "Prefab/UI/Item/WaveTagItem"}






-- PrefabList[_C.UI.WINDOW.MAIN]           = { Class = UI.MainWindow,              Path = "Prefab/UI/Window/MainWindow",           Pause   = false}

PrefabList[_C.UI.WINDOW.SYSTEMPOPUP]    = { Class = UI.SystemPopupWindow,       Path = "Prefab/UI/Window/SystemPopupWindow"}
PrefabList[_C.UI.WINDOW.BATTLE]         = { Class = UI.BattleWindow,            Path = "Prefab/UI/Window/BattleWindow"}
PrefabList[_C.UI.WINDOW.PAUSE]          = { Class = UI.PauseWindow,             Path = "Prefab/UI/Window/PauseWindow"}
PrefabList[_C.UI.WINDOW.VICTORY]        = { Class = UI.VictoryWindow,           Path = "Prefab/UI/Window/VictoryWindow"}
PrefabList[_C.UI.WINDOW.LOSE]           = { Class = UI.LoseWindow,              Path = "Prefab/UI/Window/LoseWindow"}







return PrefabList