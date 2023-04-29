--施法

local Cast = Class.define("Battle.Cast", Battle.Action)

function Cast:ctor(owner, tag)
    super(Battle.Cast, self, "ctor", owner, tag) 
    

end

function Cast:Begin()
    super(Battle.Cast, self, "Begin")

end

function Cast:Update(deltaTime)
    super(Battle.Cast, self, "Update", deltaTime)  

    --正在施法中
    if self.Owner:IsCasting() == true then
        return
    end

    local skills = self.Owner:GetPlayableSkills()

    for i = skills:Count(), 1, -1 do
        local sk = skills:Get(i)
        local flag, targets = Logic.TargetFilter.Check(sk)
        if flag == true then
            sk:Cast(targets)
            break
        end
    end
end

function Cast:Terminate()
    super(Battle.Cast, self, "Terminate")  

end

return Cast