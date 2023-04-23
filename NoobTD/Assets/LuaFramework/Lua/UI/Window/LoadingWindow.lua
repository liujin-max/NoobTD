

local LoadingWindow = {}
setmetatable(LoadingWindow, {__index = WindowBase})


function LoadingWindow.Awake(items)
    LoadingWindow.PARAMS.Progress       = items["Progress"]


    LoadingWindow.PARAMS.Progress.fillAmount    = 0
end

function LoadingWindow.IsFinished()
    return LoadingWindow.PARAMS.Progress.fillAmount >= 1
end

function LoadingWindow.Update()
    LoadingWindow.PARAMS.Progress.fillAmount    = LoadingWindow.PARAMS.Progress.fillAmount + Time.deltaTime
end


function LoadingWindow.OnDestroy()

end

return LoadingWindow