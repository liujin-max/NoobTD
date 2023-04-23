--Action: 某种行为
--一般行为分为Begin,Update,Terminate三个阶段

local Action = Class.define("Dungeon.Action")

function Action:ctor(doer, tag)
    self.Doer = doer
    self.Tag  = tag
    self.Done = false
end

function Action:Begin()

end

function Action:Update(deltaTime)

end

function Action:Terminate()

end

return Action