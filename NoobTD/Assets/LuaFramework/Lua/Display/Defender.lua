local Defender = Class.define("Display.Defender")

function Defender:ctor(model)
    self.Model  = model


    LuaEventManager.AddHandler(_E.BATTLE_DEFENDER_CLICK,    self.OnClick,  self, self)
end

function Defender:Decorate()
    self.Entity = AssetManager:LoadSync("Prefab/Battle/Defender")
    self.Entity.transform:SetParent(Battle.FIELD.Land.Avatar.Root.transform)
    self.Entity.transform.localScale      = Vector3.one
    self.Entity.transform.localPosition   = self.Model.Pos
end


function Defender:Update(deltaTime)
   
end

function Defender:OnClick(event, entity)
    if entity ~= self.Entity  then return end

    LuaEventManager.SendEvent(_E.U2U_DEFENDER_CLICK, nil, self.Model)
end

function Defender:Dispose()
    if self.Entity ~= nil then
        destroy(self.Entity)
    end
    self.Entity  = nil

    LuaEventManager.DelHandler(_E.BATTLE_DEFENDER_CLICK,    self.OnClick,  self, self)
end

return Defender