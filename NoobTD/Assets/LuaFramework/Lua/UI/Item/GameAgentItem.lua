local GameAgentItem = {}

function GameAgentItem:Awake(items)
    self.GO             = items["This"]
    self.Title          = items["Title"]
    self.ProgressBar    = items["ProgressBar"]
    self.Progress       = items["Progress"]
    self.AgentState     = items["AgentState"]
    self.BtnAvert       = items["BtnAvert"]
    self.Type           = items["Type"]
    self.Fetter         = items["Fetter"]


    UIEventListener.PGet(self.BtnAvert, self).onClick_P = function()
        Controller.Advert.Start(self.Data)
    end
end

function GameAgentItem:GetData()
    return self.Data
end

function GameAgentItem:Init(game)
    self.Data       = game
    self.Title.text = game.Name

    self:FlushUI()
end

function GameAgentItem:FlushUI()
    local game      = self.Data
    local agentor   = Controller.Data.Agentor()

    local progress  = agentor.CDTimer:GetProgress()
    self.ProgressBar.fillAmount = progress
    self.Progress.text  = math.floor(progress * 100) .. "%"

    local fetter        = game.Fetter
    self.Fetter.text    = _C.COLOR.FETTER[fetter.ID] .. fetter.Name .. "</color>"
    self.Type.text      = game.Type.Name .. "/" .. game.Theme.Name

    local day       = Controller.Data.Date():GetDay():GetCurrent()
    self.AgentState.text  = _C.NAME.AGENT[game.Process]
end

function GameAgentItem:OnDestroy()

end


return GameAgentItem