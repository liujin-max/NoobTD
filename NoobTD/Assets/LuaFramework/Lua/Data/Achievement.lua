
local Achievement = Class.define("Data.Achievement")


function Achievement:SyncMSG(msg)
    if msg.Tasks ~= nil then
        for _,cfg in ipairs(msg.Tasks) do
            local t     = self.TaskDic[cfg.ID]
            assert(t, "task is nil : " .. tostring(cfg.ID))
            t:SyncMSG(cfg)
        end
    end    
end

function Achievement:ctor()
    self.Tasks      = Class.new(Array)
    self.TaskDic    = {}
    self.Triggers   = {}

    Table.Each(Table.AchievementTable,  function(config)
        local task  = Class.new(Data.AchievementTask, config)
        self.Tasks:Add(task)
        self.TaskDic[task.ID] = task

        if self.Triggers[task:GetTriggerType()] == nil then
            self.Triggers[task:GetTriggerType()]    = Class.new(Array)
        end

        self.Triggers[task:GetTriggerType()]:Add(task)
    end)

    self.Tasks:SortBy("ID", false)
    for _,array in pairs(self.Triggers) do
        array:SortBy("ID", false)
    end

    LuaEventManager.AddHandler(_E.ACHIEVE_TRIGGER,          self.OnAchievementTrigger,  self,   self)
end

function Achievement:GetTasks()
    return self.Tasks
end



----------------------------Handler----------------------------
function Achievement:OnAchievementTrigger(event, achievement_trigger, params)
    local array     = self.Triggers[achievement_trigger]

    if array == nil then
        return
    end

    array:Each(function(task)
        if task:IsFinished() == false then
            if task:Check(params) == true then
                task:Execute()
            end
        end
    end)
end



return Achievement