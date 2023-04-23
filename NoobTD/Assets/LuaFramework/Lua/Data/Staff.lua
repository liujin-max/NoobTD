--员工

local Staff = Class.define("Data.Staff")

function Staff:Export()
    local staff_table   = 
    {
        ID              = self.ID,
        Name            = self.Name,
        JobID           = self.Job.ID,
        DebugTimer      = self.DebugTimer:GetCurrent()
    }

    staff_table.Attributes    = {}
    for k,v in pairs(self.Attributes) do
        table.insert(staff_table.Attributes, {ID = k, Value = v})
    end

    staff_table.AttributeADD    = {}
    for k,v in pairs(self.AttributeADD) do
        table.insert(staff_table.AttributeADD, {ID = k, Value = v})
    end

    staff_table.CDs     = {}
    for k, cd_timer in pairs(self.CDs) do
        table.insert(staff_table.CDs, {ID = k, Value = cd_timer:GetCurrent(), Total = cd_timer:GetTotal()})
    end

    staff_table.Skills  = {}
    for i = 1, self.Skills:Count() do
        local sk        = self.Skills:Get(i)
        table.insert(staff_table.Skills, sk:Export())
    end


    return staff_table
end

function Staff:SyncMSG(msg)
    if msg.Name ~= nil then
        self.Name   = msg.Name
    end

    if msg.JobID ~= nil then
        local job   = Controller.Data.Menu():GetJob(msg.JobID)
        self:JobUpgrade(job)
    end   
    
    if msg.DebugTimer ~= nil then
        self.DebugTimer:SetCurrent(msg.DebugTimer)
    end

    if msg.Attributes ~= nil then
        for _,cfg in ipairs(msg.Attributes) do
            self.Attributes[cfg.ID] = cfg.Value
        end
    end

    if msg.AttributeADD ~= nil then
        for _,cfg in ipairs(msg.AttributeADD) do
            self.AttributeADD[cfg.ID] = cfg.Value
        end
    end

    if msg.CDs ~= nil then
        for _,cfg in ipairs(msg.CDs) do
            self.CDs[cfg.ID]:Set(cfg.Value, cfg.Total)
        end
    end

    if msg.Skills ~= nil then
        self:ClearSkills()

        for _,cfg in ipairs(msg.Skills) do
            self:AddSkill(cfg.ID)
        end
    end
end

function Staff:ctor(config)
    self.ID         = config.ID
    self.Name       = config.Name
    self.HireDes    = config.HireDes
    self.FireDes    = config.FireDes

    self.Job        = Class.new(Data.Job, Table.Get(Table.JobTable, config.Job))
    assert(self.Job,   "未找到这个职业：" .. tostring(config.Job))


    self.DebugTimer = Class.new(Logic.CDTimer, 1.5)
    self.DebugSpeed = Class.new(Data.AttributeValue, 1)


    --属性
    self.Attributes = {}
    self.Attributes[_C.ATTRIBUTE.SPEED]     = config.Speed
    self.Attributes[_C.ATTRIBUTE.PLAN]      = config.Plan
    self.Attributes[_C.ATTRIBUTE.PROGRAM]   = config.Program
    self.Attributes[_C.ATTRIBUTE.ARTS]      = config.Arts
    self.Attributes[_C.ATTRIBUTE.MUSIC]     = config.Music


    --属性成长  
    self.AttributeADD                       = {}
    self.AttributeADD[_C.ATTRIBUTE.SPEED]   = 0
    self.AttributeADD[_C.ATTRIBUTE.PLAN]    = 0
    self.AttributeADD[_C.ATTRIBUTE.PROGRAM] = 0
    self.AttributeADD[_C.ATTRIBUTE.ARTS]    = 0
    self.AttributeADD[_C.ATTRIBUTE.MUSIC]   = 0

    --额外属性 (不保存)
    self.AttributeExtra                       = {}
    self.AttributeExtra[_C.ATTRIBUTE.SPEED]   = 0
    self.AttributeExtra[_C.ATTRIBUTE.PLAN]    = 0
    self.AttributeExtra[_C.ATTRIBUTE.PROGRAM] = 0
    self.AttributeExtra[_C.ATTRIBUTE.ARTS]    = 0
    self.AttributeExtra[_C.ATTRIBUTE.MUSIC]   = 0


    self.CDs                            = {}
    self.CDs[_C.ATTRIBUTE.SPEED]        = Class.new(Logic.CDTimer, 1)
    self.CDs[_C.ATTRIBUTE.PLAN]         = Class.new(Logic.CDTimer, 1)
    self.CDs[_C.ATTRIBUTE.PROGRAM]      = Class.new(Logic.CDTimer, 1)
    self.CDs[_C.ATTRIBUTE.ARTS]         = Class.new(Logic.CDTimer, 1)
    self.CDs[_C.ATTRIBUTE.MUSIC]        = Class.new(Logic.CDTimer, 1)


    self.Skills         = Class.new(Array)

    self.BugRate        = Class.new(Data.AttributeValue, 0)     --额外产出bug的概率
    self.MultiRate      = Class.new(Data.AttributeValue, 0)     --产出五彩球的概率
    self.RainBowRate    = Class.new(Data.AttributeValue, 0)     --产出彩虹球的概率
end

function Staff:AddSkill(skill_id)
    local sk    = Class.new(Data.Skill, Table.Get(Table.SkillTable, skill_id), self)
    sk:Equip()
    self.Skills:Add(sk)
end

function Staff:ClearSkills()
    self.Skills:Each(function(sk)
        sk:UnEquip()        
    end)
    self.Skills:Clear()
end


function Staff:JobUpgrade(job)
    self.Job        = clone(job)

    self.Skills:Each(function(sk)
        sk:Flush()
    end)
end

function Staff:GetAttributeShow()
    local array     = Class.new(Array)

    for k,v in pairs(self.Attributes) do
        if k ~= _C.ATTRIBUTE.SPEED then
            array:Add({Type = k, Value = self:GetAttribute(k)})
        end
    end
    array:SortBy("Type", false)
    return array
end

function Staff:GetAttribute(attribute_type)
    if attribute_type == _C.ATTRIBUTE.SPEED then
        return self.Attributes[attribute_type] + self.AttributeADD[attribute_type] + self.Job:GetSpeed()
    end
    return self.Attributes[attribute_type] + self.AttributeADD[attribute_type] + self.AttributeExtra[attribute_type]
end

function Staff:GetAttributeLimit(attribute_type)
    return self.Attributes[attribute_type] + self.Job:GetAttribute(attribute_type)
end

function Staff:IsAttributeLimit(attribute_type)
    return self:GetAttribute(attribute_type) >= self:GetAttributeLimit(attribute_type)
end

function Staff:ResetCD(attribute_type, game)
    local value     = self:GetAttribute(attribute_type)
    --每2秒产出 (value / 10)点，则每秒的产量为 1 / (value / 10 / 5)
    local base      = 1 / (value / 10 / 5)

    --速度设计为1-100
    if attribute_type == _C.ATTRIBUTE.SPEED then
        base        = 30 / value * math.log(value)  -- 10->1.3
    else
        --随着value变大，base需要递减
        base        = base * math.log(value) --11 -> 0.42
    end

    local cd_max    = Utility.Random.Range(math.floor(base * 0.6 * 100), math.floor(base * 1.4 * 100)) / 100.0

    --为了平衡网络和单机游戏的不同开发时长导致的能力值变化
    -- if game ~= nil then
    --     local rate  = game.Progress:GetTotal() / 50
    --     cd_max      = cd_max * rate
    -- end

    self.CDs[attribute_type]:Reset(cd_max)
end

function Staff:Reset(game)
    for k,v in pairs(self.CDs) do
        self:ResetCD(k, game)
    end
end

function Staff:Training(attribute_type, value)
    self.AttributeADD[attribute_type]   = self.AttributeADD[attribute_type] + value
end

function Staff:UpdateExtra(attribute_type, value)
    self.AttributeExtra[attribute_type]   = self.AttributeExtra[attribute_type] + value
end

--@region 制作游戏状态
function Staff:GAME_Start(game)
    self:Reset(game)

    for k,v in pairs(self.CDs) do
        v:SetCurrent(v:GetTotal() * Utility.Random.Range(85, 99) / 100.0)
    end
end

function Staff:GAME_Update(game , factory, delta_time)
    local fetter    = game.Fetter
    local speed     = fetter:GetSpeed()

    --收尾阶段
    if game:GetProcess() == _C.GAME.PROCESS.DEBUG then
        if game:GetAttribute(_C.ATTRIBUTE.BUG) > 0 then
            self.DebugTimer:Update(delta_time * self.DebugSpeed:ToNumber())
            if self.DebugTimer:IsFinished() == true then
                self.DebugTimer:Reset()
    
                game:AddAttribute(_C.ATTRIBUTE.BUG, -1)
                Controller.Data.Account():UpdateResearch(1)
                
                LuaEventManager.SendEvent(_E.ORB_DEBUG, nil)
            end 
        end
    else
        --
        for attribute_type , count in pairs(self.CDs) do
            self.CDs[attribute_type]:Update(delta_time * speed)
            if self.CDs[attribute_type]:IsFinished() == true then
                self:ResetCD(attribute_type, game)
                
                if Utility.Random.IsHit(self.MultiRate:ToNumber()) then --五彩
                    factory.OrbControl:PushBubble(_C.ATTRIBUTE.MULTI, 1, game)

                elseif Utility.Random.IsHit(self.RainBowRate:ToNumber()) then --彩虹球
                    factory.OrbControl:PushBubble(_C.ATTRIBUTE.RAINBOW, 1, game)

                else
                    if attribute_type == _C.ATTRIBUTE.SPEED then
                        --根据其他几项能力的值为权重，随机出N个能力值添加
                        local rand  = game:GeneratorBubbleValue()
    
                        local temp  = {}
                        for k,v in pairs(self.Attributes) do
                            if k ~= _C.ATTRIBUTE.SPEED  then
                                temp[k] = {Type = k, Value = self:GetAttribute(attribute_type)}
                            end
                        end
                            
                        local cfg = Utility.Random.TableWeightedPick("Value", temp)
                        factory.OrbControl:PushBubble(cfg.Type, rand, game)
                    else
                        --改版本 不产生bug球
                        -- local bug_rate  = self.BugRate:ToNumber() + fetter:GetBugBase()
                        -- local type      = Utility.Random.IsHit(bug_rate) == true and _C.ATTRIBUTE.BUG or attribute_type
    
                        factory.OrbControl:PushBubble(attribute_type, 1, game)
                    end
                end
            end
        end
    end
end
--@endregion


--@region 制作主机状态
function Staff:CONSOLE_Start()
    self:Reset()

    for k,v in pairs(self.CDs) do
        v:SetCurrent(v:GetTotal() * 0.8)
    end
end

function Staff:CONSOLE_Update(hardware, delta_time)
    local speed     = hardware:GetSpeed() / 100.0

    for attribute_type , count in pairs(self.CDs) do
        self.CDs[attribute_type]:Update(delta_time * speed)

        if self.CDs[attribute_type]:IsFinished() == true then
            self:ResetCD(attribute_type)
            
            if attribute_type == _C.ATTRIBUTE.SPEED then
                --根据其他几项能力的值为权重，随机出N个能力值添加
                for i = 1, 2 do
                    local temp  = {}
                    for k,v in pairs(self.Attributes) do
                        if k ~= _C.ATTRIBUTE.SPEED  then
                            temp[k] = {Type = k, Value = self:GetAttribute(attribute_type)}
                        end
                    end

                    local cfg = Utility.Random.TableWeightedPick("Value", temp)
                    hardware:AddAttribute(cfg.Type, 1)
                end
            else
                hardware:AddAttribute(attribute_type, 1)
            end
        end
    end
end
--@endregion


--@region 制作外包状态
function Staff:OUTSOURCE_Start()
    self:Reset()

    for k,v in pairs(self.CDs) do
        v:SetCurrent(v:GetTotal() * 0.5)
    end
end

function Staff:OUTSOURCE_Update(outsource, delta_time)
    for attribute_type , count in pairs(self.CDs) do
        self.CDs[attribute_type]:Update(delta_time)

        if self.CDs[attribute_type]:IsFinished() == true then
            self:ResetCD(attribute_type)
            
            if attribute_type == _C.ATTRIBUTE.SPEED then
                --根据其他几项能力的值为权重，随机出N个能力值添加
                local pick_count = Utility.Random.Range(1, 3)
                for i = 1, pick_count do
                    local temp  = outsource:GetSurplusAttributes()
                    if #temp > 0 then
                        local type = temp[Utility.Random.Range(1, #temp)]
                        outsource:AddAttribute(type, 1)
                    end
                end
            else
                outsource:AddAttribute(attribute_type, 1)
            end
        end
    end
end
--@endregion
----------------------------------------------------------------------------------------------

--总薪水算法
--当前职业薪水X
--当前平均能力值 N

--下一阶段平均薪水 Y
--下一阶段平均能力值 M
-- X + (Y - X) * (N / M)
function Staff:GetSalary(job)
    local atr_data  = {}
    if job ~= nil then
        atr_data  = Controller.Data.School().GeneratorUpgradeData(self, job)
    else
        job     = self.Job
    end

    local X     = job:GetSalary()

    local N     = 0
    local attributes = job.Attributes

    for k,v in pairs(attributes) do
        N       = N + self.AttributeADD[k] + (atr_data[k] or 0)
    end
    N           = N / PairCount(attributes)

    -- print("测试输出 当前职业薪水 ： " .. X)


    local Y     = 0
    local M     = 0

    local nexts = job:GetNexts()
    if #nexts > 0 then
        for _,job_id in ipairs(nexts) do
            local job   = Controller.Data.Menu():GetJob(job_id)
            Y           = Y + job:GetSalary()
    
            local avg   = 0
            for k,v in pairs(job.Attributes) do
                avg     = avg + v
            end
            avg         = avg / PairCount(job.Attributes)
            M           = M + avg
        end
    
        M           = M / #nexts
        Y           = Y / #nexts
    else
        for k,v in pairs(attributes) do
            M       = M + v
        end
        M           = M / PairCount(attributes)
        Y           = X + 10000
    end

    local salary    = round(X + (Y - X) * (N / M))

    -- print("测试输出 当前职业薪水：" .. X .. ", 平均能力值 : " .. N .. ", 下阶段薪水：" .. Y .. ", 平均能力值： " .. M)
    -- print("测试输出 最终薪水： " .. salary)

    return salary
end

function Staff:GetSkillDescription()
    local description   = ""

    for i = 1, self.Skills:Count() do
        local sk    = self.Skills:Get(i)
        if description == "" then
            description = sk:Description()
        else
            description = description .. "\n" .. sk:Description()
        end
    end

    return description
end


function Staff:Display(parent)
    self.Entity = Class.new(Display.Avatar, self, parent)
end

function Staff:UnDisplay()
    self.Entity:Dispose()
    self.Entity = nil
end




return Staff