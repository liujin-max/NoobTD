
local BattleWindow = {}
setmetatable(BattleWindow, {__index = WindowBase})

local P     = {}


local function get_wave_item(i)
    local item  = P.WaveItems:Get(i)
    if item == nil then
        item    = UI.Manager:LoadItem(_C.UI.ITEM.WAVETAG, BattleWindow.PARAMS.Pivot)

        P.WaveItems:Add(item)
    end
    item.GO:SetActive(true)
    return item
end

function BattleWindow.Awake(items)
    BattleWindow.PARAMS.BtnPause    = items["BtnPause"]

    BattleWindow.PARAMS.Pivot       = items["Pivot"]
    BattleWindow.PARAMS.BuildPivot  = items["BuildPivot"]
    BattleWindow.PARAMS.HP          = items["HP"]
    BattleWindow.PARAMS.Coin        = items["Coin"]
    BattleWindow.PARAMS.WaveCount   = items["WaveCount"]


    P.WaveItems     = Class.new(Array)



    UI.Manager:RegisterBtnScale(BattleWindow.PARAMS.BtnPause)

    UIEventListener.PGet(BattleWindow.PARAMS.BtnPause,  BattleWindow).onClick_P = function()
        Logic.Battle.Pause()
    end

    LuaEventManager.AddHandler(_E.BATTLE_DOWN,          BattleWindow.OnSceneDown,   BattleWindow,   BattleWindow)
    LuaEventManager.AddHandler(_E.U2U_DEFENDER_CLICK,   BattleWindow.OnDefendClick, BattleWindow,   BattleWindow)

    LuaEventManager.AddHandler(_E.BATTLE_HIDERING,      BattleWindow.OnHideRing,    BattleWindow,   BattleWindow)
    LuaEventManager.AddHandler(_E.BATTLE_WP_START,      BattleWindow.OnWaveTagStart,BattleWindow,   BattleWindow)
    LuaEventManager.AddHandler(_E.BATTLE_WP_TOUCH,      BattleWindow.OnWaveTagEnd,  BattleWindow,   BattleWindow)
    LuaEventManager.AddHandler(_E.BATTLE_WP_COUNTDOWN,  BattleWindow.OnWaveTagEnd,  BattleWindow,   BattleWindow)

    UpdateManager.AddHandler(BattleWindow)
end

function BattleWindow.Init()
    BattleWindow.UpdateInfo()
end

function BattleWindow.UpdateInfo()
    BattleWindow.PARAMS.HP.text             = Battle.FIELD:GetHP()
    BattleWindow.PARAMS.Coin.text           = Battle.FIELD:GetCoin()

    if Battle.FIELD:IsStart() == true then
        BattleWindow.PARAMS.WaveCount.text  = Battle.FIELD:CurrentWave():GetOrder() .. "/" .. Battle.FIELD:GetWaveCount()
    else
        BattleWindow.PARAMS.WaveCount.text  = "1/" .. Battle.FIELD:GetWaveCount()
    end
    
end

function BattleWindow.Update()
    BattleWindow.UpdateInfo()

    P.WaveItems:Each(function(item)
        if item.Wave:IsCountDown() == true then
            item:Update()
        end        
    end)
end

--两种情况
--1.点击空白的防守位，弹出建造选项
--2.点击有塔的防守位，弹出塔的选项
function BattleWindow.ShowBuildPivot(pos, defender)
    Battle.FIELD.Handler:Cancel()

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

        Battle.FIELD.Handler:ShowRange(true , tower.ID, tower.Avatar:GetPosition())
    end
end

function BattleWindow.HideBuildPivot()
    Battle.FIELD.Handler:Cancel()

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

function BattleWindow.OnWaveTagStart(pself, event, wave)
    P.WaveItems:Each(function(item)
        item.GO:SetActive(false)        
    end)

    local lines     = Battle.FIELD.Land:GetLines()

    for i, order in ipairs(wave.Lines) do
        local line  = lines:Get(order)

        local pos   = line.TagPos * 100

        local item  = get_wave_item(i)
        item.GO.transform.localPosition = pos
        item:Init(wave)
    end
end

function BattleWindow.OnWaveTagEnd(pself, event)
    P.WaveItems:Each(function(item)
        item.GO:SetActive(false)        
    end)
end


function BattleWindow.OnDestroy()
    P   = {}

    LuaEventManager.DelHandler(_E.BATTLE_DOWN,          BattleWindow.OnSceneDown,   BattleWindow)
    LuaEventManager.DelHandler(_E.U2U_DEFENDER_CLICK,   BattleWindow.OnDefendClick, BattleWindow)

    LuaEventManager.DelHandler(_E.BATTLE_HIDERING,      BattleWindow.OnHideRing,    BattleWindow)
    LuaEventManager.DelHandler(_E.BATTLE_WP_START,      BattleWindow.OnWaveTagStart,BattleWindow)
    LuaEventManager.DelHandler(_E.BATTLE_WP_TOUCH,      BattleWindow.OnWaveTagEnd,  BattleWindow)
    LuaEventManager.DelHandler(_E.BATTLE_WP_COUNTDOWN,  BattleWindow.OnWaveTagEnd,  BattleWindow)

    UpdateManager.DelHandler(BattleWindow)
end



return BattleWindow