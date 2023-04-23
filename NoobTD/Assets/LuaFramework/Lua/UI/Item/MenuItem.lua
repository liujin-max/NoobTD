local MenuItem = {}


local function SetInfo(obj, ui_menu, if_light)
    local bottom    = obj:GetComponent("Image")
    local icon      = obj.transform:Find("Icon"):GetComponent("Image")
    local name      = obj.transform:Find("Name"):GetComponent("TextMeshProUGUI")

    name.text       = ui_menu.Name

    icon.sprite     = AssetManager:LoadSprite(ui_menu.Icon,          icon.gameObject)
    icon:SetNativeSize()

    if if_light == true then
        bottom.sprite   = AssetManager:LoadSprite(ui_menu.LightPath,    bottom.gameObject)
    else
        bottom.sprite   = AssetManager:LoadSprite(ui_menu.NormalPath,    bottom.gameObject)
    end
    bottom:SetNativeSize()
end

function MenuItem:Awake(items)
    self.GO         = items["This"]
    self.Normal     = items["Normal"]
    self.Light      = items["Light"]
end

function MenuItem:Init(ui_menu)
    self.UIMenu     = ui_menu

    SetInfo(self.Normal, ui_menu)
    SetInfo(self.Light, ui_menu, true)
end

function MenuItem:Show(flag)
    self.Normal:SetActive(not flag)
    self.Light:SetActive( flag)
end


function MenuItem:OnDestroy()

end


return MenuItem