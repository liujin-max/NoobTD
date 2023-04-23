--DataController:

local DataController = {}

local P = {}

function DataController.Awake()

    LuaEventManager.AddHandler(_E.SECOND_PASSED,            DataController.OnSecondPassed,  DataController, DataController)
end

function DataController.Start()
    P.Date          = Class.new(Data.Date)


end

function DataController.LoadRecord()
    P.Date:SyncMSG(RecordController.GetDate())
end



-------- GET / SET --------
function DataController.Date()
    return P.Date
end


---------------------------
---------------------------

function DataController.Update(deltaTime)

end

function DataController.OnSecondPassed()
    
end

return DataController