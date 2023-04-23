--信息结构

local Message = Class.define("Data.Message")

function Message:ctor(data)
    self.Date           = data.Date
    self.Description    = data.Description
end




return Message