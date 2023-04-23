local Land = Class.define("Display.Land")

function Land:ctor(land)
    self.LandData   = land

    self.Root       = GameObject.Find("ROOT")
end

function Land:Display()
    self.Entity     = AssetManager:LoadSync("Prefab/Battle/BattleLand")
    self.Entity.transform:SetParent(self.Root.transform)
    self.Entity.transform.localScale      = Vector3.one
    self.Entity.transform.localPosition   = Vector3.zero
end

function Land:Dispose()
    if self.Entity ~= nil then
        destroy(self.Entity)
    end
    self.Entity  = nil
end


function Land:Update(deltaTime)
   
end


return Land