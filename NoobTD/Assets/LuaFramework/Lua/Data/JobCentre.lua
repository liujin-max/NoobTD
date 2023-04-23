--人才市场

local JobCentre = Class.define("Data.JobCentre")

function JobCentre:Export()
    local job_centre_table  = {}
    job_centre_table.ID     = self.ID
    job_centre_table.CDTimer= self.CDTimer:GetCurrent()

    job_centre_table.Pool   = {}

    self.Pool:Each(function(staff)
        table.insert(job_centre_table.Pool, staff:Export())
    end)

    return job_centre_table
end

function JobCentre:SyncMSG(msg)
    self.UnLockFlag = true
      
    if msg.CDTimer ~= nil then
        self.CDTimer:SetCurrent(msg.CDTimer)
    end

    if msg.Pool ~= nil then
        self.Pool:Clear()

        for _, cfg in ipairs(msg.Pool) do
            local staff = Class.new(Data.Staff, Table.Get(Table.StaffTable, cfg.ID))
            staff:SyncMSG(cfg)
            
            self.Pool:Add(staff)
        end
    end
end

function JobCentre:ctor(config)
    self.ID         = config.ID
    self.Name       = config.Name
    self.Cost       = config.Cost
    self.Description= config.Description
    self.Level      = config.Level
    self.SkillWeight= config.SkillWeight
    self.JobWeight  = config.JobWeight
    self.Rate       = config.Rate

    --人才池
    self.Pool       = Class.new(Array)


    self.UnLockFlag = false

    self.CDTimer    = Class.new(Logic.CDTimer, config.Times)
end

function JobCentre:Unlock()
    self.UnLockFlag = true
end

function JobCentre:IsUnlock()
    return self.UnLockFlag
end

function JobCentre:GetCost()
    return self.Cost
end

function JobCentre:GetPool()
    return self.Pool
end

--生成员工池
function JobCentre:GeneratorPool()
    self.Pool:Clear()

    local ret           = Class.new(Array)

    Table.Each(Table.StaffTable, function(cfg)
        if Controller.Data.Account():GetCompany():GetStaff(cfg.ID) == nil then
            ret:Add(cfg.ID)
        end
    end)

    --设置技能权重
    local skills        = {}
    Table.Each(Table.SkillTable, function(cfg)
        local data      = clone(cfg)
        data.weight     = self.SkillWeight[data.Level] or 0
        skills[data.ID] = data
    end)

    --设置职业权重
    local jobs          = {}
    local job_array     = Controller.Data.Menu():GetJobs()
    job_array:Each(function(job)
        local data      = {ID = job.ID, weight = self.JobWeight[job.Level]}
        jobs[data.ID] = data
    end)


    local pick_count    = Utility.Random.Range(2, 3)
    local picked        = Utility.Random.Pick(pick_count, ret)

    picked:Each(function(stf_id)
        local staff     = Class.new(Data.Staff, Table.Get(Table.StaffTable, stf_id))
        
        ----为staff做随机处理----  
        --生成随机名字
        staff.Name      = random_name()

        --生成随机职业
        --根据jobCentre的level， 随机对应的job
        --招聘级别越高 越容易招到高等级的职业
        local job_cfg   = Utility.Random.TableWeightedPick("weight", jobs)
        local pick_job  = Controller.Data.Menu():GetJob(job_cfg.ID)
        -- local atr_data  = Controller.Data.School().GeneratorUpgradeData(staff, pick_job)

        -- for k,v in pairs(staff.AttributeADD) do
        --     local offset= atr_data[k]
        --     if offset ~= nil then
        --         staff.AttributeADD[k] = staff.AttributeADD[k] + offset
        --     end
        -- end

        staff:JobUpgrade(pick_job)

        --根据职业生成随机属性
        for k,v in pairs(staff.Attributes) do
            if k == _C.ATTRIBUTE.SPEED then
                staff.Attributes[k] = pick_job:GetSpeed() --Utility.Random.Range(1, 3) * self.Level
            else
                local min           = math.floor(pick_job:GetAttribute(k) * 0.4)
                local max           = math.floor(pick_job:GetAttribute(k) * 0.6)
                -- staff.Attributes[k] = Utility.Random.Range(5, 10) * self.Level
                staff.Attributes[k] = Utility.Random.Range(min, max)
            end
        end
        
        
        --生成随机技能
        if Utility.Random.IsHit(self.Rate) == true then
            local cfg = Utility.Random.TableWeightedPick("weight", skills)
            staff:AddSkill(cfg.ID) 
        end

        ------------------------

        
        self.Pool:Add(staff)
    end)

end

return JobCentre