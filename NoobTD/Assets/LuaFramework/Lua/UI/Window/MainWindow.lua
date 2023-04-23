
local MainWindow = {}
setmetatable(MainWindow, {__index = WindowBase})

local P     = {}

local function NewGameItem()
    if P.GameItem == nil then
        -- P.GameItem  = UI.Manager:LoadItem(_C.UI.ITEM.GAME, MainWindow.PARAMS.GamePivot)
        P.GameItem  = UI.Manager:LoadSceneItem(_C.UI.ITEM.GAME, "GamePivot")
    end
    P.GameItem.GO:SetActive(true)

    return P.GameItem
end

local function NewAgentItem()
    if P.AgentItem == nil then
        P.AgentItem  = UI.Manager:LoadItem(_C.UI.ITEM.GAMEAGENT, MainWindow.PARAMS.GamePivot)
    end
    P.AgentItem.GO:SetActive(true)

    return P.AgentItem
end

local function NewOutsourceItem()
    if P.OutsourceItem == nil then
        P.OutsourceItem  = UI.Manager:LoadItem(_C.UI.ITEM.OUTSOURCE, MainWindow.PARAMS.GamePivot)
    end
    P.OutsourceItem.GO:SetActive(true)

    return P.OutsourceItem
end


local function NewHardwareItem()
    if P.HardwareItem == nil then
        P.HardwareItem  = UI.Manager:LoadItem(_C.UI.ITEM.HARDWARE, MainWindow.PARAMS.HardwarePivot)
    end
    P.HardwareItem.GO:SetActive(true)

    return P.HardwareItem
end

local function NewReportItem(game)
    local path  = _C.UI.ITEM.SALEREPORT
    if game:IsNetwork() then
        path  = _C.UI.ITEM.NETWORKREPORT
    end

    local item  = UI.Manager:LoadItem(path, MainWindow.PARAMS.ReportPivot)
    -- local item  = UI.Manager:LoadSceneItem(path, "ReportPivot")
    item.GO:SetActive(true)

    P.ReportItems:Add(item)

    UISimpleEventListener.PGet(item.Bottom, item).onClick_P = function()
        Controller.Advert.Start(game)
    end

    return item
end

local function ShowGamePivot(flag)
    if P.GameItem ~= nil then
        P.GameItem.GO:SetActive(flag)
    end
end

local function ShowAgentPivot(flag)
    if P.AgentItem ~= nil then
        P.AgentItem.GO:SetActive(flag)
    end
end

local function ShowOutsourcePivot(flag)
    if P.OutsourceItem ~= nil then
        P.OutsourceItem.GO:SetActive(flag)
    end
end

local function ShowHardwarePivot(flag)
    MainWindow.PARAMS.HardwarePivot:SetActive(flag)
end

function MainWindow.Awake(items)
    MainWindow.PARAMS.Date          = items["Date"]
    MainWindow.PARAMS.Money         = items["Money"]
    MainWindow.PARAMS.Description   = items["Description"]
    MainWindow.PARAMS.Fans          = items["Fans"]
    MainWindow.PARAMS.Research      = items["Research"]
    MainWindow.PARAMS.ClockHand     = items["ClockHand"]
    MainWindow.PARAMS.NewsPivot     = items["NewsPivot"]
    MainWindow.PARAMS.News          = items["News"]

    MainWindow.PARAMS.GamePivot     = items["GamePivot"]
    MainWindow.PARAMS.HardwarePivot = items["HardwarePivot"]
    MainWindow.PARAMS.ReportPivot   = items["ReportPivot"]
    MainWindow.PARAMS.MessagePivot  = items["MessagePivot"]

    MainWindow.PARAMS.Clock         = items["Clock"]
    MainWindow.PARAMS.Mask          = items["Mask"]

    P.ReportItems   = Class.new(Array)
    P.MessageItems  = Class.new(Array)

    UIEventListener.PGet(MainWindow.PARAMS.Mask,        MainWindow).onClick_P = function()
        Logic.Navigation.GotoMenu()
    end

    UIEventListener.PGet(MainWindow.PARAMS.Clock,       MainWindow).onClick_P = function()
        if ConstManager.Console == true then
            UI.Manager:LoadUIWindow(_C.UI.WINDOW.GM, UI.Manager.BORAD)
        end
    end


    LuaEventManager.AddHandler(_E.GAME_BUILDING_START,      MainWindow.OnGameBuildingStart,     MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.GAME_BUILDING_SHOW,       MainWindow.OnGameBuildingShow,      MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.GAME_BUILDING_END,        MainWindow.OnGameBuildingEnd,       MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.GAME_BUILDING_CANCEL,     MainWindow.OnGameBuildingCancel,    MainWindow, MainWindow)

    LuaEventManager.AddHandler(_E.GAME_AGENT_START,         MainWindow.OnGameAgentStart,        MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.GAME_AGENT_SHOW,          MainWindow.OnGameAgentShow,         MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.GAME_AGENT_END,           MainWindow.OnGameAgentEnd,          MainWindow, MainWindow)

    LuaEventManager.AddHandler(_E.GAME_AGENT_TEST_UPDATE,   MainWindow.OnGameAgentTestUpdate,   MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.GAME_AGENT_TEST_END,      MainWindow.OnGameAgentTestEnd,      MainWindow, MainWindow)

    LuaEventManager.AddHandler(_E.GAME_RELEASE_START,       MainWindow.OnGameReleaseStart,      MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.GAME_RELEASE_SHOW,        MainWindow.OnGameReleaseShow,       MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.GAME_RELEASE_END,         MainWindow.OnGameReleaseEnd,        MainWindow, MainWindow)

    LuaEventManager.AddHandler(_E.HARDWARE_BUILDING_START,  MainWindow.OnHardwareBuildingStart, MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.HARDWARE_BUILDING_SHOW,   MainWindow.OnHardwareBuildingShow,  MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.HARDWARE_BUILDING_END,    MainWindow.OnHardwareBuildingEnd,   MainWindow, MainWindow)

    LuaEventManager.AddHandler(_E.OUTSOURCE_BUILDING_START, MainWindow.OnOutsourceStart,        MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.OUTSOURCE_BUILDING_SHOW,  MainWindow.OnOutsourceShow,         MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.OUTSOURCE_BUILDING_END,   MainWindow.OnOutsourceEnd,          MainWindow, MainWindow)


    LuaEventManager.AddHandler(_E.MAIN_WINDOW_FLUSH,        MainWindow.OnFlushUI,               MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.M2U_SHOWNEWS,             MainWindow.OnNewsShow,              MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.GAME_UI_ATTRIBUTE,        MainWindow.OnGameAttributeFlush,    MainWindow, MainWindow)
    LuaEventManager.AddHandler(_E.GAME_PUSH_MESSAGE,        MainWindow.OnGamePushMessage,       MainWindow, MainWindow)

    UpdateManager.AddHandler(MainWindow)    
end

function MainWindow.Init()
    MainWindow.FlushUI()

    MainWindow.PARAMS.NewsPivot:SetActive(false)
    ShowGamePivot(false)
    ShowAgentPivot(false)
    ShowHardwarePivot(false)
    ShowOutsourcePivot(false)
end

function MainWindow.GetGameAttributePivot(attribute_type)
    if P.GameItem == nil then
        return 
    end

    return P.GameItem:GetAttributePivot(attribute_type)
end


function MainWindow.FlushUI()
    local money_text    = Controller.Data.Account():GetMoneyText()
    if Controller.Data.Account():GetMoney() < 0 then
        MainWindow.PARAMS.Money.text    = _C.COLOR.RED .. money_text .. "</color>"
    else
        MainWindow.PARAMS.Money.text    = money_text
    end

    MainWindow.PARAMS.Research.text = Controller.Data.Account():GetResearchCount()
    MainWindow.PARAMS.Fans.text     = Controller.Data.Fans():GetFansText()
end

function MainWindow.Update()
    --@region 刷新时钟
    MainWindow.PARAMS.Date.text = Controller.Data.Date():GetDateText()

    local rate  = Controller.Data.Date():GetDay():GetProgress()
    MainWindow.PARAMS.ClockHand.transform.localEulerAngles  = Vector3.New(0, 0, -360 * rate)
    --@endregion

end

function MainWindow.PushMessage(game)
    local message   = Data.Commenter.PickOne(game)
    local item      = UI.Manager:LoadItem(_C.UI.ITEM.MESSAGE, MainWindow.PARAMS.MessagePivot)
    item:Init(message)
    P.MessageItems:Add(item)

    item:Show()
    StartCoroutine(function()
        WaitForSeconds(0.5)

        item.GO.transform:DOLocalMove(Vector3.New(0, 200, 0), 1):OnComplete(function()
            P.MessageItems:Remove(item)
            destroy(item.GO)
        end)

        WaitForSeconds(0.8)
        item:Hide()
    end)
end

---------------------------------------------------------------------------
function MainWindow.OnFlushUI(pself, event)
    MainWindow.FlushUI()
end

function MainWindow.OnNewsShow(pself, event, description, delay_time)
    if P.NewsCoroutine ~= nil then
        StopCoroutine(P.NewsCoroutine)
        P.NewsCoroutine = nil
    end

    MainWindow.PARAMS.NewsPivot:SetActive(true)
    MainWindow.PARAMS.News.text = description


    P.NewsCoroutine = StartCoroutine(function()
        local ani   = MainWindow.GO:GetComponent("Animation")
        ani:Play("ShowNews")

        WaitForSeconds(delay_time or 1)
        MainWindow.PARAMS.NewsPivot:SetActive(false)
        P.NewsCoroutine = nil
    end)
end



--@region 开发过程
--游戏
function MainWindow.OnGameBuildingStart(pself, event, game)
    P.GameItem = NewGameItem()
    P.GameItem:Init(game)
end

function MainWindow.OnGameBuildingShow(peself, event, game)
    MainWindow.FlushUI()

    if P.GameItem == nil then
        P.GameItem = NewGameItem()
        P.GameItem:Init(game)    
    end

    P.GameItem:FlushUI()
    ShowGamePivot(true)
end

function MainWindow.OnGameBuildingEnd(peself, event, game)
    MainWindow.FlushUI()

    P.GameItem:FlushUI()
    ShowGamePivot(false)
end

function MainWindow.OnGameBuildingCancel(peself, event, game)
    ShowGamePivot(false)
end

function MainWindow.OnGameAttributeFlush(pself, event, attribute_type, value)
    if P.GameItem == nil then
        return
    end

    local value = math.floor(value)
    local now   = P.GameItem:GetAttribute(attribute_type)
    if value ~= now then
        P.GameItem:AddAttribute(attribute_type, value - now)
    end
end


function MainWindow.OnGameAgentStart(pself, event, game)
    P.AgentItem = NewAgentItem()
    P.AgentItem:Init(game)
end

function MainWindow.OnGameAgentShow(peself, event, game)
    MainWindow.FlushUI()

    if P.AgentItem == nil then
        P.AgentItem = NewAgentItem()
        P.AgentItem:Init(game)    
    end

    P.AgentItem:FlushUI()
    ShowAgentPivot(true)
end

function MainWindow.OnGameAgentEnd(peself, event, game)
    MainWindow.FlushUI()

    ShowAgentPivot(false)
end

function MainWindow.OnGameAgentTestUpdate(peself, event, game)
    if P.MessageEffect == nil then
        P.MessageEffect = Display.EffectManager.Add("Prefab/Effects/fx_message", MainWindow.PARAMS.MessagePivot, Vector3.New(-50,20,0))
        P.MessageEffect.Entity.transform.localScale = P.MessageEffect.Entity.transform.localScale * 0.5 
    end

    P.MessageEffect:Show(P.MessageItems:Count() == 0)
end

function MainWindow.OnGameAgentTestEnd(peself, event, game)
    Display.EffectManager.Remove(P.MessageEffect)
    P.MessageEffect = nil
end

function MainWindow.OnGamePushMessage(pself, event, game)
    MainWindow.PushMessage(game)
end



--主机
function MainWindow.OnHardwareBuildingStart(pself, event, hardware)
    P.HardwareItem = NewHardwareItem()
    P.HardwareItem:Init(hardware)

    ShowHardwarePivot(true)
end

function MainWindow.OnHardwareBuildingShow(peself, event, hardware)
    MainWindow.FlushUI()

    if P.HardwareItem == nil then
        P.HardwareItem = NewHardwareItem()
        P.HardwareItem:Init(hardware)    
    end

    P.HardwareItem:FlushUI()

    ShowHardwarePivot(true)
end

function MainWindow.OnHardwareBuildingEnd(peself, event, hardware)
    MainWindow.FlushUI()

    P.HardwareItem:FlushUI()
    ShowHardwarePivot(false)
end

--@endregion

--@region 发行过程
function MainWindow.OnGameReleaseStart(pself, event, game)
    MainWindow.FlushUI()

    local item  = NewReportItem(game)
    item:Init(game)
    item.GO:SetActive(false)
end

function MainWindow.OnGameReleaseShow(pself, event, game)
    MainWindow.FlushUI()

    local is_exist  = false
    for i = 1, P.ReportItems:Count() do
        local item  = P.ReportItems:Get(i)
        if item.Game == game then
            is_exist= true
            break
        end
    end

    if is_exist == false then
        local item  = NewReportItem(game)
        item:Init(game)
    end

    P.ReportItems:Each(function(item)
        item.GO:SetActive(true)
        item:FlushUI()
    end)
end

function MainWindow.OnGameReleaseEnd(pself, event, game)
    MainWindow.FlushUI()

    for i = P.ReportItems:Count(), 1, -1 do
        local item  = P.ReportItems:Get(i)
        if item:GetGame() == game then
            destroy(item.GO)
            P.ReportItems:Remove(item)
        end
    end
end

--@endregion


--@region 外包
function MainWindow.OnOutsourceStart(pself, event, out_source)
    P.OutsourceItem = NewOutsourceItem()
    P.OutsourceItem:Init(out_source)
end

function MainWindow.OnOutsourceShow(peself, event, out_source)
    MainWindow.FlushUI()

    if P.OutsourceItem == nil then
        P.OutsourceItem = NewOutsourceItem()
        P.OutsourceItem:Init(out_source)    
    end

    P.OutsourceItem:FlushUI()
    ShowOutsourcePivot(true)

end

function MainWindow.OnOutsourceEnd(peself, event, out_source)
    MainWindow.FlushUI()

    ShowOutsourcePivot(false)
end
--@endregion






function MainWindow.OnDestroy()
    if P.NewsCoroutine ~= nil then
        StopCoroutine(P.NewsCoroutine)
    end

    P   = {}

    LuaEventManager.DelHandler(_E.GAME_BUILDING_START,      MainWindow.OnGameBuildingStart,     MainWindow)
    LuaEventManager.DelHandler(_E.GAME_BUILDING_SHOW,       MainWindow.OnGameBuildingShow,      MainWindow)
    LuaEventManager.DelHandler(_E.GAME_BUILDING_END,        MainWindow.OnGameBuildingEnd,       MainWindow)
    LuaEventManager.DelHandler(_E.GAME_BUILDING_CANCEL,     MainWindow.OnGameBuildingCancel,    MainWindow)

    LuaEventManager.DelHandler(_E.GAME_AGENT_START,         MainWindow.OnGameAgentStart,        MainWindow)
    LuaEventManager.DelHandler(_E.GAME_AGENT_SHOW,          MainWindow.OnGameAgentShow,         MainWindow)
    LuaEventManager.DelHandler(_E.GAME_AGENT_END,           MainWindow.OnGameAgentEnd,          MainWindow)

    LuaEventManager.DelHandler(_E.GAME_AGENT_TEST_UPDATE,   MainWindow.OnGameAgentTestUpdate,   MainWindow)
    LuaEventManager.DelHandler(_E.GAME_AGENT_TEST_END,      MainWindow.OnGameAgentTestEnd,      MainWindow)

    LuaEventManager.DelHandler(_E.GAME_RELEASE_START,       MainWindow.OnGameReleaseStart,      MainWindow)
    LuaEventManager.DelHandler(_E.GAME_RELEASE_SHOW,        MainWindow.OnGameReleaseShow,       MainWindow)
    LuaEventManager.DelHandler(_E.GAME_RELEASE_END,         MainWindow.OnGameReleaseEnd,        MainWindow)

    LuaEventManager.DelHandler(_E.HARDWARE_BUILDING_START,  MainWindow.OnHardwareBuildingStart, MainWindow)
    LuaEventManager.DelHandler(_E.HARDWARE_BUILDING_SHOW,   MainWindow.OnHardwareBuildingShow,  MainWindow)
    LuaEventManager.DelHandler(_E.HARDWARE_BUILDING_END,    MainWindow.OnHardwareBuildingEnd,   MainWindow)

    LuaEventManager.DelHandler(_E.OUTSOURCE_BUILDING_START, MainWindow.OnOutsourceStart,        MainWindow)
    LuaEventManager.DelHandler(_E.OUTSOURCE_BUILDING_SHOW,  MainWindow.OnOutsourceShow,         MainWindow)
    LuaEventManager.DelHandler(_E.OUTSOURCE_BUILDING_END,   MainWindow.OnOutsourceEnd,          MainWindow)

    LuaEventManager.DelHandler(_E.MAIN_WINDOW_FLUSH,        MainWindow.OnFlushUI,               MainWindow)
    LuaEventManager.DelHandler(_E.M2U_SHOWNEWS,             MainWindow.OnNewsShow,              MainWindow)
    LuaEventManager.DelHandler(_E.GAME_UI_ATTRIBUTE,        MainWindow.OnGameAttributeFlush,    MainWindow)
    LuaEventManager.DelHandler(_E.GAME_PUSH_MESSAGE,        MainWindow.OnGamePushMessage,       MainWindow)

    UpdateManager.DelHandler(MainWindow)
end



return MainWindow