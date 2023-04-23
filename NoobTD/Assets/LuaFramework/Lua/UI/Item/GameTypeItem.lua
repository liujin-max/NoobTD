local GameTypeItem = {}

function GameTypeItem:Awake(items)
    self.GO         = items["This"]
    self.Bottom     = items["Bottom"]
    self.Name       = items["Name"]
    self.Cost       = items["Cost"]
    self.Level      = items["Level"]
    self.Fetter     = items["Fetter"]

end


function GameTypeItem:Init(game_type)
    self.Data       = game_type
    self.Name.text  = game_type.Name
    self.Level.text = "Lv." .. game_type:GetLevel()


    self.Bottom.sprite  = AssetManager:LoadSprite("Icon/Universal/Universal_game_item_bottom", self.Bottom.gameObject)


    local cost      = game_type:GetCost()
    if Controller.Data.IsMoneyEnough(cost) == true then
        self.Cost.text  = game_type:GetCost() .. "元"
    else
        self.Cost.text  = _C.COLOR.RED .. game_type:GetCost() .. "元" .. "</color>"
    end

    self.Fetter.text    = "<#C0C0C0>???</color>"

    local theme     = Controller.Main.GameTheme()
    if theme ~= nil then
        local cfg   = Controller.Data.Menu():GetFetterDic(game_type, theme)
        if cfg ~= nil then
            self.Fetter.text    = _C.COLOR.FETTER[cfg.ID] .. cfg.Name .. "</color>"
        end
    end
end


function GameTypeItem:OnDestroy()

end


return GameTypeItem