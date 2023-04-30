
local BattleWindow = {}
setmetatable(BattleWindow, {__index = WindowBase})

local P     = {}


local function new_build_item(i)
    local item = P.BuildItems:Get(i)
    if item == nil then
        item    = UI.Manager:LoadItem(_C.UI.ITEM.BUILD, BattleWindow.PARAMS.BuildPivot.transform)
        P.BuildItems:Add(item)
    end
    item.GO:SetActive(true)
    return item
end

function BattleWindow.Awake(items)
    BattleWindow.PARAMS.BuildPivot  = items["BuildPivot"]


    P.BuildItems    = Class.new(Array)

    P.BuildEffects  = 
    {
        Class.new(Logic.EventEffect, 1000, 10000),
        Class.new(Logic.EventEffect, 1000, 20000),
        Class.new(Logic.EventEffect, 1000, 30000)
    }


    LuaEventManager.AddHandler(_E.BATTLE_DOWN,          BattleWindow.OnSceneDown,   BattleWindow,   BattleWindow)
    LuaEventManager.AddHandler(_E.U2U_DEFENDER_CLICK,   BattleWindow.OnDefendClick, BattleWindow,   BattleWindow)
end

function BattleWindow.Init()

end

--两种情况
--1.点击空白的防守位，弹出建造选项
--2.点击有塔的防守位，弹出塔的选项
function BattleWindow.ShowBuildPivot(pos, defender)
    pos = pos * 100

    BattleWindow.PARAMS.BuildPivot:SetActive(true)
    BattleWindow.PARAMS.BuildPivot.transform.localPosition  = pos

    P.BuildItems:Each(function(item)
        item.GO:SetActive(false)
    end)

    local tower = defender:GetTower()
    if tower == nil then
        local count     = #P.BuildEffects

        for i, effect in ipairs(P.BuildEffects) do
            local item = new_build_item(i)
            item:Init(effect)

            local angle = 360 / count * (i - 1)
            local pos   = Logic.Battle.angle_radius_point(Vector3.zero, angle, 200)
            item.GO.transform.localPosition = pos

            UIEventListener.PGet(item.GO,  BattleWindow).onClick_P = function()
                effect:Execute({Defender = defender})

                BattleWindow.HideBuildPivo()
            end
        end
    else
        BattleWindow.PARAMS.BuildPivot:SetActive(false)
    end
end

function BattleWindow.HideBuildPivo()
    BattleWindow.PARAMS.BuildPivot:SetActive(false)
end

function BattleWindow.OnDefendClick(pself, event, defender)
    local pos   = defender:CenterPos()

    BattleWindow.ShowBuildPivot(pos, defender)
end

function BattleWindow.OnSceneDown(pself, event)
    BattleWindow.HideBuildPivo()
end


function BattleWindow.OnDestroy()
    P   = {}

    LuaEventManager.DelHandler(_E.BATTLE_DOWN,          BattleWindow.OnSceneDown,   BattleWindow)
    LuaEventManager.DelHandler(_E.U2U_DEFENDER_CLICK,   BattleWindow.OnDefendClick, BattleWindow)
end



return BattleWindow