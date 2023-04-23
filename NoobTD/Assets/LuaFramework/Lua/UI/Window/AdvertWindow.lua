local AdvertWindow = {}
setmetatable(AdvertWindow, {__index = WindowBase})

local P     = {}


function AdvertWindow.Awake(items)
    AdvertWindow.PARAMS.Mask        = items["Mask"]
    AdvertWindow.PARAMS.BtnClose    = items["BtnClose"]

    AdvertWindow.PARAMS.Pivot       = items["Pivot"]


    UIEventListener.PGet(AdvertWindow.PARAMS.Mask,  AdvertWindow).onClick_P = function()
        Controller.Advert.Dispose()
    end

    UIEventListener.PGet(AdvertWindow.PARAMS.BtnClose,  AdvertWindow).onClick_P = function()
        Controller.Advert.Dispose()
    end


end

function AdvertWindow.Init(game)
    P.Game  = game

    AdvertWindow.UpdateAdverts()
end

function AdvertWindow.UpdateAdverts()
    local adverts   = Controller.Data.Propaganda():GetAdverts()

    adverts:Each(function(advert)
        local obj   = AdvertWindow.PARAMS.Pivot.transform:Find(tostring(advert.ID))
        if obj ~= nil then
            local name  = obj.transform:Find("Name"):GetComponent("TextMeshProUGUI")
            local btn   = obj.transform:Find("BtnConfirm").gameObject
            local cost  = obj.transform:Find("BtnConfirm/Cost"):GetComponent("TextMeshProUGUI")
            local mask  = obj.transform:Find("Mask").gameObject

            name.text   = advert.Name
            mask:SetActive(advert:IsUnlock() == false)

            local c_m   = advert:GetCost()
            if Controller.Data.IsMoneyEnough(c_m) == true then
                cost.text   = SetShowNumber(c_m)
            else
                cost.text   = _C.COLOR.RED .. SetShowNumber(c_m) .. "</color>"
            end

            UIEventListener.PGet(btn,   AdvertWindow).onClick_P = function()
                Controller.Advert.Execute(advert, P.Game)
            end
        end
    end)
end


function AdvertWindow.OnDestroy()
    P   = {}
end



return AdvertWindow