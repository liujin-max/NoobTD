--管理各种功能的解锁
--解锁的同时可以根据效果器做一些表现
--均为一次性的 FinishFlag

local FunctionMgr = Class.define("Data.FunctionMgr")


function FunctionMgr:GetData(id)
    local data  = self.DataDic[id]
    assert(data, "data is nil : " .. tostring(id))
    return data 
end

function FunctionMgr:GetDatas()
    return self.Datas
end

function FunctionMgr:SyncMSG(msg)
    if msg.Datas ~= nil then
        for _,cfg in ipairs(msg.Datas) do
            local f = self:GetData(cfg.ID)
            f:SyncMSG(cfg)
        end
    end    
end

function FunctionMgr:ctor()
    self.Datas      = Class.new(Array)
    self.DataDic    = {}

    Table.Each(Table.FunctionsTable,   function(config)
        local data  = Class.new(Data.Functions, config)
        self.Datas:Add(data)
        self.DataDic[data.ID] = data
    end)
end

function FunctionMgr:Update(delta_time)
    self.Datas:Each(function(data)
        if data:IsFinished() == false then
            if data:Check() == true then
                data:Execute()
            end
        end
    end)
end


return FunctionMgr