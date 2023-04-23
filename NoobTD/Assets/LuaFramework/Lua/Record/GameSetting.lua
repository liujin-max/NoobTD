
GameSetting = {}


--存储键
GameSetting.KEY                     = {}




function GameSetting.GetBool(key)
    return PlayerPrefsManager.GetIntByKey(key) == 1
end

function GameSetting.SetBool(key, flag)
    PlayerPrefsManager.SetIntKey(key, flag == true and 1 or 0)
end

function GameSetting.GetValue(key)
    return PlayerPrefsManager.GetIntByKey(key)
end

function GameSetting.SetValue(key, value)
    PlayerPrefsManager.SetIntKey(key, value)
end