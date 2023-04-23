local AgentorBarItem = {}

function AgentorBarItem:Awake(items)
    self.GO     = items["This"]
    self.Name   = items["Name"]
    self.Level  = items["Level"]
    self.Bar    = items["Bar"]

    self.IsOver = false
end


function AgentorBarItem:Init(agent, level_data)
    self.Agent      = agent

    self.Name.text  = agent.Name

    self.LevelData  = level_data
    self.CExp       = level_data.OExp
end

function AgentorBarItem:FlushLevel()
    local percent       = self.CExp / self.Agent.Intimacy 
    self.Level.text     = string.format("%d%%", percent * 100)
    self.Bar.fillAmount = percent
end


function AgentorBarItem:FlushUI()
    if self.IsOver == true then return end

    self.CExp   = self.CExp + Time.deltaTime 
    self.CExp   = math.min(self.CExp, self.LevelData.NExp)
    if self.CExp == self.LevelData.NExp then
        self.IsOver = true
    end

    self:FlushLevel()
end

function AgentorBarItem:OnDestroy()

end


return AgentorBarItem