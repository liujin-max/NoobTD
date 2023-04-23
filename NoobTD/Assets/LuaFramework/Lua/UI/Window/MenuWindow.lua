local MenuWindow = {}
setmetatable(MenuWindow, {__index = WindowBase})

local P     = {}


local function NewOptionItem(idx)
    local item  = P.OptionItems:Get(idx)
    if item == nil then
        item    = UI.Manager:LoadItem(_C.UI.ITEM.MENUOPTION, MenuWindow.PARAMS.OptionContent)

        P.OptionItems:Add(item)
    end
    item.GO:SetActive(true)
    return item
end

function MenuWindow.Awake(items)
    MenuWindow.PARAMS.Mask          = items["Mask"]

    MenuWindow.PARAMS.MenuPivot     = items["MenuPivot"]
    MenuWindow.PARAMS.OptionContent = items["OptionContent"]

    P.OptionItems   = Class.new(Array)

    UIEventListener.PGet(MenuWindow.PARAMS.Mask,    MenuWindow).onClick_P = function()
        UI.MenuWindow.ProgressHide(UI.MenuWindow,_C.UI.WINDOW.MENU)
    end
end

function MenuWindow.Init()
    MenuWindow.InitMenus()
end

function MenuWindow.InitMenus()
    local ui_menus  = Controller.Data.Menu():GetUIMenus()

    for i = 1, ui_menus:Count() do
        local menu  = ui_menus:Get(i)

        local item  = UI.Manager:LoadItem(_C.UI.ITEM.MENU, MenuWindow.PARAMS.MenuPivot)
        item:Init(menu)
        item:Show(false)

        if i == 1 then
            MenuWindow.SelectMenuItem(item)
        end

        UISimpleEventListener.PGet(item.Normal,     item).onClick_P = function()
            if P.MenuItem == item then return end

            MenuWindow.SelectMenuItem(item)
        end
    end
end

function MenuWindow.SelectMenuItem(item)
    if P.MenuItem ~= nil then
        P.MenuItem:Show(false)
    end

    P.MenuItem   = item
    P.MenuItem:Show(true)
    MenuWindow.UpdateOptions(item.UIMenu)
end

function MenuWindow.UpdateOptions(menu)
    P.OptionItems:Each(function(item)
        item.GO:SetActive(false)        
    end)

    local array     = Class.new(Array)
    local count     = 1
    local options   = menu:GetOptions()
    for i = 1, options:Count() do
        local op    = options:Get(i)
        if op:IsUnlock() == true or op.ForceShow == true then
            local item  = NewOptionItem(count)
            item:Init(op)
            item.GO:SetActive(false)
            array:Add(item)
            count   = count + 1
        end
    end

    local times     = 0.1 * count
    local cdtimer   = 0
    local cc        = 1

    if P.Timer ~= nil then
        UpdateManager.UnRegisterTimer(P.Timer)
    end

    P.Timer =  Logic.TimeCounter.Register(times, nil, 
    function(delta_time)
        cdtimer     = cdtimer + delta_time
        if cdtimer >= 0.1 then
            cdtimer = cdtimer - 0.1

            if cc <= array:Count() then
                local item = array:Get(cc)
                item.GO:SetActive(true)
                item:Show()
                cc      = cc + 1 
            end
        end
    end,
    function()
        array:Each(function(item)
            item.GO:SetActive(true)
        end)
    end)
end

function MenuWindow.OnDestroy()
    if P.Timer ~= nil then
        UpdateManager.UnRegisterTimer(P.Timer)
    end

    P     = {}
end



return MenuWindow