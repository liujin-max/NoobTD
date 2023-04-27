local Grid = Class.define("Display.Grid")

function Grid:ctor(Grid, grid_cfg)
    self.GridData   = Grid


end

function Grid:Decorate(parent, pos_x, pos_y)
    self.Entity = AssetManager:LoadSync("Prefab/Battle/BattleGrid")
    self.Entity.transform:SetParent(parent.transform)
    self.Entity.transform.localScale      = Vector3.one
    self.Entity.transform.localPosition   = Battle.Grid.GetPos(self.PosX, self.PosY)
end

function Grid:Dispose()
    if self.Entity ~= nil then
        destroy(self.Entity)
    end
    self.Entity  = nil
end


function Grid:Update(deltaTime)
   
end


return Grid