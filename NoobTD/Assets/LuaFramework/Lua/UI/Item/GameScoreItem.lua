local GameScoreItem = {}

function GameScoreItem:Awake(items)
    self.GO         = items["This"]
    self.Score      = items["Score"]
    self.ScoreBar   = items["ScoreBar"]
end

function GameScoreItem:Init(number)
    local score_text        = string.format("%.1f", number)
    local score_parameters  = split(score_text, ".")

    if tonumber(score_parameters[1]) == 10 then
        self.Score.text         = score_parameters[1]
    else
        self.Score.text         = score_parameters[1] .. "." .. "<size=30>" .. score_parameters[2] .. "</size>"
    end
    self.ScoreBar.fillAmount= number / 10
end

function GameScoreItem:OnDestroy()

end


return GameScoreItem