
local BattleWindow = {}
setmetatable(BattleWindow, {__index = WindowBase})

local P     = {}




function BattleWindow.Awake(items)
    BattleWindow.PARAMS.BtnPause    = items["BtnPause"]


    BattleWindow.PARAMS.BuildPivot  = items["BuildPivot"]
    BattleWindow.PARAMS.HP          = items["HP"]
    BattleWindow.PARAMS.Coin        = items["Coin"]
    BattleWindow.PARAMS.MonsterCount= items["MonsterCount"]






    UI.Manager:RegisterBtnScale(BattleWindow.PARAMS.BtnPause)

    UIEventListener.PGet(BattleWindow.PARAMS.BtnPause,  BattleWindow).onClick_P = function()
        Logic.Battle.Pause()
    end

    LuaEventManager.AddHandler(_E.BATTLE_DOWN,          BattleWindow.OnSceneDown,   BattleWindow,   BattleWindow)
    LuaEventManager.AddHandler(_E.U2U_DEFENDER_CLICK,   BattleWindow.OnDefendClick, BattleWindow,   BattleWindow)

    LuaEventManager.AddHandler(_E.BATTLE_HIDERING,      BattleWindow.OnHideRing,    BattleWindow,   BattleWindow)
    

    UpdateManager.AddHandler(BattleWindow)
end

function BattleWindow.Init()
    BattleWindow.UpdateInfo()
end

function BattleWindow.UpdateInfo()
    BattleWindow.PARAMS.HP.text             = Battle.FIELD:GetHP()
    BattleWindow.PARAMS.Coin.text           = Battle.FIELD:GetCoin()
    BattleWindow.PARAMS.MonsterCount.text   = Battle.FIELD:GetMonsterCount()
end

function BattleWindow.Update()
    BattleWindow.UpdateInfo()

end

--两种情况
--1.点击空白的防守位，弹出建造选项
--2.点击有塔的防守位，弹出塔的选项
function BattleWindow.ShowBuildPivot(pos, defender)
    pos = pos * 100

    BattleWindow.PARAMS.BuildPivot:SetActive(true)
    BattleWindow.PARAMS.BuildPivot.transform.localPosition  = pos

    if P.ScaleCoroutin ~= nil then
        StopCoroutine(P.ScaleCoroutin)
    end
    
    if P.BuildItem == nil then
        P.BuildItem = UI.Manager:LoadItem(_C.UI.ITEM.BUILDRING, BattleWindow.PARAMS.BuildPivot)
    end

    local tower = defender:GetTower()
    if tower == nil then
        P.BuildItem:ShowBuilding(defender)
        P.BuildItem:Show()
    else
        P.BuildItem:ShowUpgrading(defender)
        P.BuildItem:Show()
    end
end

function BattleWindow.HideBuildPivot()
    if P.BuildItem ~= nil then
        P.BuildItem:Hide()

        if P.ScaleCoroutin ~= nil then
            StopCoroutine(P.ScaleCoroutin)
        end

        P.ScaleCoroutin = StartCoroutine(function()
            WaitForSeconds(0.1)

            BattleWindow.PARAMS.BuildPivot:SetActive(false)

            P.ScaleCoroutin = nil
        end)
    else
        BattleWindow.PARAMS.BuildPivot:SetActive(false)
    end

end

function BattleWindow.OnDefendClick(pself, event, defender)
    local pos   = defender:CenterPos()

    BattleWindow.ShowBuildPivot(pos, defender)
end

function BattleWindow.OnSceneDown(pself, event)
    BattleWindow.HideBuildPivot()
end

function BattleWindow.OnHideRing(pself, event)
    BattleWindow.HideBuildPivot()
end


function BattleWindow.OnDestroy()
    P   = {}

    LuaEventManager.DelHandler(_E.BATTLE_DOWN,          BattleWindow.OnSceneDown,   BattleWindow)
    LuaEventManager.DelHandler(_E.U2U_DEFENDER_CLICK,   BattleWindow.OnDefendClick, BattleWindow)

    LuaEventManager.DelHandler(_E.BATTLE_HIDERING,      BattleWindow.OnHideRing,    BattleWindow)


    UpdateManager.DelHandler(BattleWindow)
end



return BattleWindow