local GameThemeItem = {}

function GameThemeItem:Awake(items)
    self.Name       = items["Name"]
    self.Cost       = items["Cost"]
    self.Level      = items["Level"]
    self.Fetter     = items["Fetter"]
end


function GameThemeItem:Init(game_theme)
    self.Data       = game_theme
    self.Name.text  = game_theme.Name
    self.Level.text = "Lv." .. game_theme:GetLevel()

    local cost      = game_theme:GetCost()
    if Controller.Data.IsMoneyEnough(cost) == true then
        self.Cost.text  = cost .. "元"
    else
        self.Cost.text  = _C.COLOR.RED .. cost .. "元" .. "</color>"
    end

    self.Fetter.text    = "<#C0C0C0>???</color>"
    local type      = Controller.Main.GameType()
    if type ~= nil then
        local cfg   = Controller.Data.Menu():GetFetterDic(type, game_theme)
        if cfg ~= nil then
            self.Fetter.text    = _C.COLOR.FETTER[cfg.ID] .. cfg.Name .. "</color>"
        end
    end
end


function GameThemeItem:OnDestroy()

end


return GameThemeItem