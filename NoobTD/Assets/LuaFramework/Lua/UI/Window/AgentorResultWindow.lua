
local AgentorResultWindow = {}
setmetatable(AgentorResultWindow, {__index = WindowBase})

local P     = {}


function AgentorResultWindow.Awake(items)
    AgentorResultWindow.PARAMS.Mask         = items["Mask"]
    AgentorResultWindow.PARAMS.Content      = items["Content"]
    AgentorResultWindow.PARAMS.CloseTip     = items["CloseTip"]

    AgentorResultWindow.PARAMS.CloseTip:SetActive(false)
  
    P.BarItems  = Class.new(Array)

    UpdateManager.AddHandler(AgentorResultWindow)
end

function AgentorResultWindow.Init(game, type_level_data, theme_level_data, agent_level_data)
    AgentorResultWindow.InitExpBar(game, type_level_data, theme_level_data, agent_level_data)
end


function AgentorResultWindow.InitExpBar(game, type_level_data, theme_level_data, agent_level_data)
    local agent         = game.Agent
    local game_type     = game.Type
    local game_theme    = game.Theme


    if agent_level_data ~= nil then
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.AGENTORBAR, AgentorResultWindow.PARAMS.Content)
        item:Init(agent, agent_level_data)
        P.BarItems:Add(item)
    end

    if type_level_data ~= nil then
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.EXPBAR, AgentorResultWindow.PARAMS.Content)
        item:Init(game_type, type_level_data)
        P.BarItems:Add(item)
    end

    if theme_level_data ~= nil then
        local item  = UI.Manager:LoadItem(_C.UI.ITEM.EXPBAR, AgentorResultWindow.PARAMS.Content)
        item:Init(game_theme, theme_level_data)
        P.BarItems:Add(item)
    end

end

function AgentorResultWindow.IsOver()
    for i = 1, P.BarItems:Count() do
        local item = P.BarItems:Get(i)
        if item.IsOver == false then
            return false
        end
    end
    return true
end

function AgentorResultWindow.FlushUI()
    P.BarItems:Each(function(item)
        item:FlushUI()
    end)
end

function AgentorResultWindow.Update()
    AgentorResultWindow.FlushUI()

    if AgentorResultWindow.IsOver() == true then
        AgentorResultWindow.PARAMS.CloseTip:SetActive(true)

        UIEventListener.PGet(AgentorResultWindow.PARAMS.Mask,   AgentorResultWindow).onClick_P = function()
            Controller.Data.Factory():TerminateCurrent()
        end
    end
end


function AgentorResultWindow.OnDestroy()
    P   = {}

    UpdateManager.DelHandler(AgentorResultWindow)
end



return AgentorResultWindow