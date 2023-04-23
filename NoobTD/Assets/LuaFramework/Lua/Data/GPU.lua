--主机gpu

local GPU = Class.define("Data.GPU", Data.ConsoleElement)


function GPU:ctor(config)
    super(Data.GPU, self, "ctor", config)

end

function GPU:Select()
    Controller.Console.SelectGPU(self)
end



return GPU