UpdateManager = {}

local obj_list          = Class.new(Array)
local time_list         = Class.new(Array)
local remove_time_list  = Class.new(Array)

function UpdateManager.AddHandler(obj)
    if obj_list:Contains(obj) then return end
    assert(type(obj) == "table", "obj should be table but " .. type(obj))
    assert(obj.__type ~= "Instance", "instance cannot be registered")

    obj_list:Add(obj)
end

function UpdateManager.DelHandler(obj)
    obj_list:Remove(obj)
end

function UpdateManager.Run(deltaTime)
    for i = obj_list:Count(), 1, -1 do
        obj_list:Get(i):Update(deltaTime)
    end
    UpdateManager.RunTimer()
end

function UpdateManager.RunTimer()
    for i = 1, remove_time_list:Count() do
        local timer = remove_time_list:Get(i)
        time_list:Remove(timer)
    end
    if remove_time_list:Count() > 0 then
        remove_time_list:Clear()
    end
    for i = 1, time_list:Count() do
        local timer = time_list:Get(i)
        timer:Update()
    end
end

function UpdateManager.IsRegistered(timer)
    return time_list:Contains(timer) ~= nil
end

function UpdateManager.RegisterTimer(timer)
    time_list:Add(timer)
end

function UpdateManager.UnRegisterTimer(timer)
    remove_time_list:Add(timer)
end