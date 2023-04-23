--负责外出打工的逻辑

local Sideline = Class.define("Data.Sideline")


function Sideline:Export()
    local temp  = {}

    temp.StartFlag  = self.StartFlag
    temp.Times      = {Value = self.Times:GetCurrent() , Total = self.Times:GetTotal()}
    temp.Reward     = self.Reward

    return temp
end

function Sideline:SyncMSG(msg)
    if msg.StartFlag ~= nil then
        self.StartFlag  = msg.StartFlag
    end

    if msg.Times ~= nil then
        self.Times:Set(msg.Times.Value, msg.Times.Total)
    end

    if msg.Reward ~= nil then
       self.Reward  = msg.Reward 
    end
end

function Sideline:ctor()
    self.Times      = Class.new(Logic.CDTimer, _C.CONST.WEEKSECOND)
    self.StartFlag  = false
    self.Reward     = 0
end

function Sideline:Start()
    self.StartFlag  = true
    self.Reward     = Utility.Random.Range(1,3) * 10000

    self.Times:Reset()
end

function Sideline:Finish()
    self.StartFlag  = false
    self.Reward     = 0

    self.Times:Reset()
end

function Sideline:Update(deltaTime)
    if self.StartFlag == false then return end

    if UI.Manager:IsWindowExist(_C.UI.WINDOW.SIDELINE) == false then
        UI.Manager:LoadUIWindow(_C.UI.WINDOW.SIDELINE, UI.Manager.MAJOR)
    end

    self.Times:Update(deltaTime)
    if self.Times:IsFinished() == true then
        UI.SidelineWindow.ProgressHide(UI.SidelineWindow,_C.UI.WINDOW.SIDELINE)

        Logic.MusicPlayer.PlaySound(SOUND.COIN)

        local coin  = self.Reward or 0
        Controller.Data.UpdateMoney(coin)
        
        Controller.System.Popup("辛苦送了一天的外卖，获得：" .. SetShowNumber(coin) .. "元", function()
            
        end, nil, true)


        Controller.Data.Sideline():Finish()
    end
end



return Sideline