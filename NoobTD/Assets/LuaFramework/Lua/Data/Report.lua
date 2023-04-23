
local Report = Class.define("Data.Report")


function Report:SyncMSG(msg)
    if msg.Timer ~= nil then
        self.Timer:Set(msg.Timer.Value, msg.Timer.Total)
    end

    if msg.Description ~= nil then
        self.Description    = msg.Description
    end
end

function Report:ctor(timer, description)
    self.Timer          = Class.new(Logic.CDTimer, timer)
    self.Description    = description
end

function Report:Execute()
    Controller.System.Popup(self.Description, nil, nil, true)
end


function Report:IsFinished()
    return self.Timer:IsFinished()
end

function Report:Update(delta_time)
    self.Timer:Update(delta_time)
end


return Report