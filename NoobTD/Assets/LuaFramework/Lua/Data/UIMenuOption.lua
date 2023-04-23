
local UIMenuOption = Class.define("Data.UIMenuOption")


function UIMenuOption:ctor(config, ui_menu)
    self.ID         = config.ID
    self.Name       = config.Name
    self.ForceShow  = config.ForceShow == 1

    self.Conditions = ParseConditions(config.Condition)
    self.Effects    = ParseEventEffect(config.Effect)
end

function UIMenuOption:IsUnlock()
    for i = 1, self.Conditions:Count() do
        local c     = self.Conditions:Get(i)
        if c:Check() == false then
            return false
        end
    end
    return true
end

function UIMenuOption:Execute()
    for i = 1, self.Conditions:Count() do
        local c     = self.Conditions:Get(i)
        if c:Check() == false then
            local des = c:Description()
            Controller.System.FlyTip(des)
            return false
        end
    end

    self.Effects:Each(function(eff)
        eff:Execute()
    end)

    return true
end



return UIMenuOption