--诞生

local Born = Class.define("Battle.Born", Battle.Action)

function Born:ctor(owner, tag)
    super(Battle.Born, self, "ctor", owner, tag) 
    

end

function Born:Begin()
    super(Battle.Born, self, "Begin")

    self.Owner.Avatar:Decorate()

    if self.Owner.Side == _C.SIDE.ATTACK then
        self.Owner.Avatar:RandomOffset()    --坐标偏移

        local route = self.Owner:GetCurrentRoute()
        if route ~= nil then
            self.Owner:SetPos(route:CenterPos())
        end

    elseif self.Owner.Side == _C.SIDE.DEFEND then
        local defender = self.Owner:GetDefender()
        if defender ~= nil then
            self.Owner:SetPos(defender:CenterPos())
        end
    end




    self.Owner.StateFlag._IsBorn = true
end

function Born:Update(deltaTime)
    super(Battle.Born, self, "Update", deltaTime)  


end

function Born:Terminate()
    super(Battle.Born, self, "Terminate")  

end

return Born