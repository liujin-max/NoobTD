--UI: Namespace
-------------------------------
UI = {}

require("UI/Window/WindowBase")
require("UI/Item/ItemBase")

UI.Manager                      = require("UI/UIManager")




UI.SystemTipItem                = require("UI/Item/SystemTipItem")
UI.SystemPopupItem              = require("UI/Item/SystemPopupItem")
UI.BuildItem                    = require("UI/Item/BuildItem")
UI.HPBar                        = require("UI/Item/HPBar")
UI.BuildRingItem                = require("UI/Item/BuildRingItem")
UI.WaveTagItem                  = require("UI/Item/WaveTagItem")






-- UI.MainWindow                   = require("UI/Window/MainWindow")
UI.SystemPopupWindow            = require("UI/Window/SystemPopupWindow")
UI.BattleWindow                 = require("UI/Window/BattleWindow")
UI.PauseWindow                  = require("UI/Window/PauseWindow")
UI.VictoryWindow                = require("UI/Window/VictoryWindow")
UI.LoseWindow                   = require("UI/Window/LoseWindow")





UI.PrefabList                   = require("UI/PrefabList")
