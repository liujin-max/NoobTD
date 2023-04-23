--主机cpu

local CPU = Class.define("Data.CPU", Data.ConsoleElement)


function CPU:ctor(config)
    super(Data.CPU, self, "ctor", config)

end

function CPU:Select()
    Controller.Console.SelectCPU(self)
end



return CPU