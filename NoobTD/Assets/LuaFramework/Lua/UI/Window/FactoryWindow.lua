
local FactoryWindow = {}
setmetatable(FactoryWindow, {__index = WindowBase})

local P     = {}


function FactoryWindow.Awake(items)
    FactoryWindow.PARAMS.Mask           = items["Mask"]
    FactoryWindow.PARAMS.BtnPause       = items["BtnPause"]
    FactoryWindow.PARAMS.BtnAuto        = items["BtnAuto"]
    FactoryWindow.PARAMS.AutoLight      = items["AutoLight"]
    FactoryWindow.PARAMS.BtnRestart     = items["BtnRestart"]

    FactoryWindow.PARAMS.ComboPivot     = items["ComboPivot"]
    FactoryWindow.PARAMS.Combo          = items["Combo"]
    FactoryWindow.PARAMS.PausePivot     = items["PausePivot"]
    FactoryWindow.PARAMS.BtnContinue    = items["BtnContinue"]
    FactoryWindow.PARAMS.BtnGiveup      = items["BtnGiveup"]

    FactoryWindow.PARAMS.TopPivot       = items["TopPivot"]




    P.ComboAnimation    = FactoryWindow.PARAMS.Combo:GetComponent("Animation")
    P.ComboCDTimer      = Class.new(Logic.CDTimer, 2)
    P.BarItems          = Class.new(Array)

    UIEventListener.PGet(FactoryWindow.PARAMS.Mask, FactoryWindow).onDown_P     = FactoryWindow.OnDown
    UIEventListener.PGet(FactoryWindow.PARAMS.Mask, FactoryWindow).onUp_P       = FactoryWindow.OnUp
    UIEventListener.PGet(FactoryWindow.PARAMS.Mask, FactoryWindow).onDrag_P     = FactoryWindow.OnDrag




    UIEventListener.PGet(FactoryWindow.PARAMS.BtnPause,     FactoryWindow).onClick_P = function()
        Controller.Data.Factory():Pause()
    end

    UIEventListener.PGet(FactoryWindow.PARAMS.BtnAuto,      FactoryWindow).onClick_P = function()
        P.Factory.OrbControl:SwitchAuto()
    end

    UIEventListener.PGet(FactoryWindow.PARAMS.BtnContinue,  FactoryWindow).onClick_P = function()
        Controller.Data.Factory():Continue()
    end

    UIEventListener.PGet(FactoryWindow.PARAMS.BtnGiveup,    FactoryWindow).onClick_P = function()
        Controller.Data.Factory():Cancel()
    end


    UIEventListener.PGet(FactoryWindow.PARAMS.BtnRestart,  FactoryWindow).onClick_P = function()
        Controller.Data.Factory():Restart()
    end

    -- UIEventListener.PGet(FactoryWindow.PARAMS.BtnFRestart,  FactoryWindow).onClick_P = function()
    --     Controller.Data.Factory():Restart()
    -- end

    UpdateManager.AddHandler(FactoryWindow)
end

function FactoryWindow.Init(factory)
    P.Factory   = factory

    FactoryWindow.PARAMS.TopPivot:SetActive(false)
    FactoryWindow.PARAMS.Mask:SetActive(false)

    FactoryWindow.ShowCombo(false, 0)
end

function FactoryWindow.Start()
    FactoryWindow.PARAMS.TopPivot:SetActive(true)
    FactoryWindow.PARAMS.Mask:SetActive(true)
end

function FactoryWindow.ShowCombo(flag, value)
    P.ComboCDTimer:Reset()

    FactoryWindow.PARAMS.ComboPivot:SetActive(flag)
    FactoryWindow.PARAMS.Combo.text = value or 0

    P.ComboAnimation:Play("ComboShow")
end

function FactoryWindow.Update()
    FactoryWindow.PARAMS.PausePivot:SetActive(Controller.Data.Factory():IsPause())
    -- FactoryWindow.PARAMS.BtnPause:SetActive(Controller.Data.Factory():IsPause() == false)

    P.ComboCDTimer:Update(Time.deltaTime)
    if P.ComboCDTimer:IsFinished() == true then
        FactoryWindow.ShowCombo(false, 0)
    end

    FactoryWindow.PARAMS.AutoLight:SetActive(P.Factory.OrbControl:IsAuto())
end


function FactoryWindow.DRAG(finger_pos_on_field)
    local orb_pos   = P.Factory.OrbControl.CurrentOrb.OriginPos * 100
    local td        = Vector2.New(finger_pos_on_field.x - orb_pos.x  , finger_pos_on_field.y - orb_pos.y)

    P.Factory.OrbControl:DRAG(1 * Vector2.Normalize(td), 1, angle_360(orb_pos, finger_pos_on_field))
end

function FactoryWindow:OnDown(go, pointerEventData)
    if P.Factory.OrbControl:CanOperator() == false then
        return
    end

    local finger_pos_on_field = GameUtil.ScenePoint2UI(pointerEventData.position, FactoryWindow.PARAMS.Mask)

    FactoryWindow.DRAG(finger_pos_on_field)
end

function FactoryWindow:OnDrag(go, pointerEventData)
    if P.Factory.OrbControl:CanOperator() == false then
        return
    end
    local finger_pos_on_field = GameUtil.ScenePoint2UI(pointerEventData.position, FactoryWindow.PARAMS.Mask)
        
    FactoryWindow.DRAG(finger_pos_on_field)
end

function FactoryWindow:OnUp(go, pointerEventData)
    if P.Factory.OrbControl:CanOperator() == false then
        return
    end
    
    P.Factory.OrbControl:GO(1 * P.Factory.OrbControl.Dir)
end


function FactoryWindow.OnDestroy()
    P   = {}

    UpdateManager.DelHandler(FactoryWindow)
end



return FactoryWindow