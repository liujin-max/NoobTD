
local SchoolWindow = {}
setmetatable(SchoolWindow, {__index = WindowBase})

local P     = {}


local function ActiveTab(type)
    Controller.School.SelectTab(type)
    
    for k,temp in pairs(P.TAB) do
        temp.InActive:SetActive(k ~= type)
        temp.Active:SetActive(k == type)
    end

    P.TrainData  = nil
    SchoolWindow.InitTrainFlags(type)
end

local function ParseTab(type, tab_btn)
    local r     = {}
    r.Button    = tab_btn
    r.InActive  = tab_btn.transform:Find("Normal").gameObject
    r.Active    = tab_btn.transform:Find("Light").gameObject

    P.TAB[type]    = r

    UIEventListener.PGet(r.Button,  SchoolWindow).onClick_P = function()
        ActiveTab(type)
    end
end

local function NewFlagItem(idx)
    local item  = P.FlagItems:Get(idx)
    if item == nil then
        item    = UI.Manager:LoadItem(_C.UI.ITEM.TRAIN, SchoolWindow.PARAMS.Content.transform)
        
        P.FlagItems:Add(item)
    end
    item.GO:SetActive(true)
    return item
end


function SchoolWindow.Awake(items)
    SchoolWindow.PARAMS.Content         = items["Content"]

    SchoolWindow.PARAMS.BtnClose        = items["BtnClose"]
    SchoolWindow.PARAMS.Mask            = items["Mask"]
    

    P.TAB    = {}
    ParseTab(_C.ATTRIBUTE.PLAN,     items["PLAN"])
    ParseTab(_C.ATTRIBUTE.PROGRAM,  items["PROGRAM"])
    ParseTab(_C.ATTRIBUTE.ARTS,     items["ARTS"])
    ParseTab(_C.ATTRIBUTE.MUSIC,    items["MUSIC"])

    P.FlagItems = Class.new(Array)


    UIEventListener.PGet(SchoolWindow.PARAMS.Mask,          SchoolWindow).onClick_P = function()
        Controller.School.End()
    end

    UIEventListener.PGet(SchoolWindow.PARAMS.BtnClose,      SchoolWindow).onClick_P = function()
        Controller.School.End()
    end
end

function SchoolWindow.Init(staff, tab_type)
    P.Staff = staff

    ActiveTab(tab_type)
end

function SchoolWindow.InitTrainFlags(type)
    P.FlagItems:Each(function(item)
        item.GO:SetActive(false)
    end)

    local flags     = Controller.Data.School():GetTrains()

    local index     = 1

    for i = flags:Count() , 1, -1 do
        local train_flag    = flags:Get(i)
        if train_flag.Type == type then
            if train_flag:IsUnlock() == true then
                local item  = NewFlagItem(index)
                item:Init(train_flag)

                UISimpleEventListener.PGet(item.GO, item).onClick_P = function()
                    Controller.School.Training(P.Staff, train_flag)
                end
        
                index   = index + 1 
            end
        end
    end
end




function SchoolWindow.OnDestroy()
    P     = {}
end



return SchoolWindow