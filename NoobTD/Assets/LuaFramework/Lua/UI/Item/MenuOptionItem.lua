local MenuOptionItem = {}

local function SetInfo(obj, menu_option)
    local o_name    = obj.transform:Find("Name"):GetComponent("TextMeshProUGUI")
    local l_name    = obj.transform:Find("Name"):GetComponent("TextMeshProUGUI")

    o_name.text     = menu_option.Name
    l_name.text     = menu_option.Name
end

function MenuOptionItem:Awake(items)
    self.GO         = items["This"]
    self.Normal     = items["Normal"]
    self.Light      = items["Light"]
    self.Gray       = items["Gray"]


    
    UISimpleEventListener.PGet(self.GO,   self).onClick_P = function()
        if self.MenuOption:Execute() == true then
            UI.Manager:UnLoadWindow(_C.UI.WINDOW.MENU)
        end
    end
    
    UISimpleEventListener.PGet(self.GO,   self).onDown_P = function()
        if self.MenuOption:IsUnlock() == false then return end
        self:ShowLight(true)
    end

    UISimpleEventListener.PGet(self.GO,   self).onUp_P = function()
        if self.MenuOption:IsUnlock() == false then return end
        self:ShowLight(false)
    end
end

function MenuOptionItem:Init(menu_option)
    self.MenuOption = menu_option
    
    SetInfo(self.Normal,    menu_option)
    SetInfo(self.Light,     menu_option)
    SetInfo(self.Gray,      menu_option)

    self:ShowLight(false)
    self.Gray:SetActive(menu_option:IsUnlock() == false)
end

function MenuOptionItem:ShowLight(flag)
    self.Normal:SetActive(flag == false)    
    self.Light:SetActive(flag)    
end

function MenuOptionItem:Show()
    local ani   = self.GO:GetComponent("Animation")   
    ani:Play("MenuOptionShow") 
end

function MenuOptionItem:OnDestroy()

end


return MenuOptionItem