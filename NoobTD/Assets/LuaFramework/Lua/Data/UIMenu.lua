
local UIMenu = Class.define("Data.UIMenu")

function UIMenu:GetOptions()
    return self.Options
end

function UIMenu:ctor(config)
    self.ID         = config.ID
    self.Name       = config.Name
    self.Icon       = config.Icon
    self.NormalPath = config.NormalPath
    self.LightPath  = config.LightPath

    self.Options    = Class.new(Array)
    for _,option_id in ipairs(config.Options) do
        local option    = Class.new(Data.UIMenuOption, Table.Get(Table.MenuOptionTable, option_id), self)
        self.Options:Add(option)
    end
    self.Options:SortBy("ID", false)
end




return UIMenu