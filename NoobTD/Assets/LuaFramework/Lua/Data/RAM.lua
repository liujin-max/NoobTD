--主机ram

local RAM = Class.define("Data.RAM", Data.ConsoleElement)


function RAM:ctor(config)
    super(Data.RAM, self, "ctor", config)

end

function RAM:Select()
    Controller.Console.SelectRAM(self)
end



return RAM