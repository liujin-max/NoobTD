require("Core/CSharpTable")
require("Common/functions")


function Update()
    local delta_time    = Time.deltaTime

    if Battle.FIELD ~= nil then
        Battle.FIELD:Update(delta_time)
    end

    Controller.Data.Update(delta_time)
    
    UpdateManager.Run(delta_time)

    RecordController.Update()
end

function GameStart()
    require("Core/RequireManager")
    require("Utility/ClockTower")

    --随机数种子
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))

    ClockTower.Awake()

    UI.Manager:Init()

    Display.EffectManager.Awake()

    
    NoobTD.GameFacade.Instance.LevelManager:LoadLevelAsync("Battle", function()
        Battle.FIELD = Class.new(Battle.Field)
        Battle.FIELD:Start()
    end)


end