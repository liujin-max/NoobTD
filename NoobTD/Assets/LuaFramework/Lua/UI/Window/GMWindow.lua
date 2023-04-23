--GMWindow: 网络控制台

local GMWindow = {}
setmetatable(GMWindow, {__index = WindowBase})


function GMWindow.Awake(items)
    GMWindow.PARAMS.TokenInput  = items["Input"]:GetComponent("InputField")
    GMWindow.PARAMS.SendBtn     = items["Login"]
    GMWindow.PARAMS.CloseBtn    = items["Close"]
    GMWindow.PARAMS.Restart     = items["Restart"]

    UIEventListener.PGet(GMWindow.PARAMS.SendBtn,   GMWindow).onClick_P     = GMWindow.OnSend

    UIEventListener.PGet(GMWindow.PARAMS.CloseBtn,  GMWindow).onClick_P     = function()
        UI.Manager:UnLoadWindow(_C.UI.WINDOW.GM)
    end

    UIEventListener.PGet(GMWindow.PARAMS.Restart,  GMWindow).onClick_P     = function()
        Controller.System.Popup("是否清空存档并退出游戏?", function()
            RecordController.Clear()
            GameUtil.OnExitGame()
        end)
    end
end


function GMWindow.OnSend()
    local cmd_text = GMWindow.PARAMS.TokenInput.text

    local cmd_parameters = split(cmd_text, " ")

    if cmd_parameters[1] == "@Date" then
        local year      = tonumber(cmd_parameters[2])
        local month     = tonumber(cmd_parameters[3])
        local week      = tonumber(cmd_parameters[4])

        local date   = (week - 1) * _C.CONST.WEEKSECOND + (month - 1) * (4 * _C.CONST.WEEKSECOND) + (year - 1) * (4 * 12 * _C.CONST.WEEKSECOND)
        print("测试输出 " .. year .. "年" .. month .. "月" .. week .. "星期：" .. date)

    elseif cmd_parameters[1] == "@Money" then   --添加金币
        Controller.Data.UpdateMoney(tonumber(cmd_parameters[2]))

    elseif cmd_parameters[1] == "@Research" then   --添加研究点
        Controller.Data.UpdateResearch(tonumber(cmd_parameters[2]))

    elseif cmd_parameters[1] == "@Fans" then   --添加粉丝
        Controller.Data.Fans():UpdateFans(tonumber(cmd_parameters[2]))

    else
        Controller.System.FlyTip("不支持哦")
    end

    Controller.System.FlyTip("发送成功")
end

function GMWindow.OnClose()
    UI.Manager:UnLoadUI(UI.GMWindow)
end


function GMWindow.OnDestroy()

end

return GMWindow