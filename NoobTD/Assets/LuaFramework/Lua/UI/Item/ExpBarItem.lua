local ExpBarItem = {}

function ExpBarItem:Awake(items)
    self.GO             = items["This"]
    self.Name           = items["Name"]
    self.Level          = items["Level"]
    self.Bar            = items["Bar"]
    self.EffectPivot    = items["EffectPivot"]

    self.IsOver = false
end

--game_data     => GameType, GameTheme
--level_data    => {OLevel, OExp, 0,NLevel, NExp}
function ExpBarItem:Init(game_data, level_data)
    self.Name.text  = game_data.Name

    self.LevelData  = level_data
    self.CLevel     = level_data.OLevel
    self.CExp       = level_data.OExp
end

function ExpBarItem:FlushLevel()
    local need          = Table.Get(Table.UpgradeLevelTable, self.CLevel).Exp
    self.Level.text     = "Lv." .. self.CLevel
    self.Bar.fillAmount = self.CExp / need
end

function ExpBarItem:FlushUI()
    if self.IsOver == true then return end

    self.CExp   = self.CExp + Time.deltaTime 

    if self.CLevel < self.LevelData.NLevel then
        local need  = Table.Get(Table.UpgradeLevelTable, self.CLevel).Exp
        if self.CExp >= need then
            self.CLevel = self.CLevel + 1
            self.CExp   = 0

            Display.EffectManager.Add("Prefab/Effects/fx_levelbar_upgrade", self.EffectPivot, Vector3.zero)
        end
    else
        self.CExp   = math.min(self.CExp, self.LevelData.NExp)
        if self.CExp == self.LevelData.NExp then
            self.IsOver = true
        end
    end

    self:FlushLevel()
end

function ExpBarItem:OnDestroy()

end


return ExpBarItem