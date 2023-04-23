local GameScoreLeftItem = {}

function GameScoreLeftItem:Awake(items)
    self.GO             = items["This"]
    self.Bottom         = items["Bottom"]
    self.Score          = items["Score"]
    self.Description    = items["Description"]

    self.CounterList    = {}
end

function GameScoreLeftItem:Init(score, description)
    self.ScoreValue     = score
    self.Comment        = description

    self.Score.text     = score

    -- self.Bottom.transform.localScale    = Vector3.New(0, 1, 1)
end

function GameScoreLeftItem:Show()
    local ani  = self.GO:GetComponent("Animation")
    ani:Play("ScoreLeftShow")

    
    local times         = 0
    self.Description.text    = ""

    table.insert(self.CounterList, Logic.TimeCounter.Register(2, nil, function(delta_time)
        self.Score.text = Utility.Random.Range(1, 10)

        times   = times + delta_time
        if times >= 0.5 then
            times   = times - 0.5

            self.Description.text    = self.Description.text .. "."
        end
    end,
    function()
        self.Score.text         = self.ScoreValue
        self.Description.text   = self.Comment
    end
))
    
end

function GameScoreLeftItem:OnDestroy()
    for i,c in ipairs(self.CounterList) do
        UpdateManager.UnRegisterTimer(c)
    end
    self.CounterList = {}
end


return GameScoreLeftItem