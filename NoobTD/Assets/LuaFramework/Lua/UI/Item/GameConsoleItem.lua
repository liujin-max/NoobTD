local GameConsoleItem = {}

function GameConsoleItem:Awake(items)
    self.Name       = items["Name"]
    self.Share      = items["Share"]

end


function GameConsoleItem:Init(game_console)
    self.Data       = game_console
    self.Name.text  = game_console.Name
    self.Share.text = game_console:GetShareRate() .. "%"
end


function GameConsoleItem:OnDestroy()

end


return GameConsoleItem