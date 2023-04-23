

local LoginWindow = {}
setmetatable(LoginWindow, {__index = WindowBase})


function LoginWindow.Awake(items)
    LoginWindow.PARAMS.BtnConfirm   = items["BtnConfirm"]

    LoginWindow.PARAMS.AdsNormal    = items["AdsNormal"]
    LoginWindow.PARAMS.AdsReward    = items["AdsReward"]
    LoginWindow.PARAMS.AdsReward2   = items["AdsReward2"]
    

    UIEventListener.PGet(LoginWindow.PARAMS.BtnConfirm,     LoginWindow).onClick_P = function()
        Logic.GameEnter.EnterNext()
        -- AdsUtil:Test();
    end

    UIEventListener.PGet(LoginWindow.PARAMS.AdsNormal,     LoginWindow).onClick_P = function()
        AdsManager:ShowNormal()
    end

    UIEventListener.PGet(LoginWindow.PARAMS.AdsReward,     LoginWindow).onClick_P = function()
        AdsManager:ShowRewarded()
    end

    UIEventListener.PGet(LoginWindow.PARAMS.AdsReward2,     LoginWindow).onClick_P = function()
        AdsManager:ShowRewarded2()
    end
end


function LoginWindow.OnDestroy()

end

return LoginWindow