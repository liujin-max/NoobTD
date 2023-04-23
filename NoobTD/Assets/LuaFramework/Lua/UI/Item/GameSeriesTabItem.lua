local GameSeriesTabItem = {}

local function SetInfo(obj, game_series)
    local o_name    = obj.transform:Find("Name"):GetComponent("TextMeshProUGUI")
    local l_name    = obj.transform:Find("Name"):GetComponent("TextMeshProUGUI")

    o_name.text     = game_series:GetName()
    l_name.text     = game_series:GetName()
end

function GameSeriesTabItem:Awake(items)
    self.GO         = items["This"]
    self.Normal     = items["Normal"]
    self.Light      = items["Light"]
end

function GameSeriesTabItem:Init(game_series)
    self.GameSeries = game_series
    
    SetInfo(self.Normal, game_series)
    SetInfo(self.Light, game_series)
end

function GameSeriesTabItem:Select(flag)
    self.Normal:SetActive(flag == false)
    self.Light:SetActive(flag == true)
end

function GameSeriesTabItem:OnDestroy()

end


return GameSeriesTabItem