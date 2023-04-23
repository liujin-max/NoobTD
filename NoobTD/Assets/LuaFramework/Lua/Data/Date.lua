--时间信息

local Date = Class.define("Data.Date")

--传入时间戳，得出该时间戳是 某年某月某周
function Date.DateString(stamp)
    local year  = 1
    local month = 1
    local week  = 1

    
    local week_step = _C.CONST.WEEKSECOND --7秒1周
    local month_step= 4
    local year_step = 12

    local count = 0
    local step  = 1
    for i = 1, stamp, step do
        count       = count + step

        if count >= week_step then
            count   = count - week_step

            week    = week + 1  --1周
        end

        if week > month_step  then
            week    = week - month_step

            month   = month + 1 --1个月
        end

        if month > year_step  then
            month   = month - year_step

            year    = year + 1  --1年
        end
    end

    local str   = year .. "年" .. month .. "月" .. week .. "周"

    return str, count
end



function Date:GetDate()
    return self.Date
end

function Date:GetDateText()
    local str   = string.format(_C.MESSAGE.FORMATEDATE, 
                                math.floor(self.Year:GetCurrent()),
                                math.floor(self.Month:GetCurrent()),
                                math.floor(self.Week:GetCurrent()))

    return str
end

function Date:GetDay()
    return self.Day
end

function Date:GetWeek()
    return self.Week
end

function Date:GetMonth()
    return self.Month
end

function Date:GetYear()
    return self.Year
end

function Date:SyncMSG(msg)
    if msg.Date ~= nil then
        self.Date   = msg.Date
    end    

    if msg.Year ~= nil then
        self.Year:SetCurrent(msg.Year)
    end

    if msg.Month ~= nil then
        self.Month:SetCurrent(msg.Month)
    end

    if msg.Week ~= nil then
        self.Week:SetCurrent(msg.Week)
    end

    if msg.Day ~= nil then
        self.Day:SetCurrent(msg.Day)
    end
end

function Date:ctor()
    self.Date   = 0

    self.Day    = Class.new(Logic.CDTimer, _C.CONST.WEEKSECOND)
    self.Week   = Class.new(Logic.CDTimer, 5)
    self.Month  = Class.new(Logic.CDTimer, 13)
    self.Year   = Class.new(Logic.CDTimer, 9999999)

    self.Week:SetCurrent(1)
    self.Month:SetCurrent(1)
    self.Year:SetCurrent(1)

end


function Date:Update(delta_time)
    local ready_save    = false

    self.Date   = self.Date + delta_time
    self.Day:Update(delta_time)
    if self.Day:IsFinished() then
        local x = self.Day:GetCurrent() - self.Day:GetTotal()
        self.Date   = self.Date - x

        self.Day:Reset()

        ready_save = true

        self.Week:Update(1)
        LuaEventManager.SendEvent(_E.DATE_FINISH_WEEK, nil)

        if self.Week:IsFinished() then
            self.Week:Reset()
            self.Week:SetCurrent(1)

            self.Month:Update(1)
            LuaEventManager.SendEvent(_E.DATE_FINISH_MONTH, nil)

            if self.Month:IsFinished() then
                self.Month:Reset()
                self.Month:SetCurrent(1)
                
                self.Year:Update(1)
                LuaEventManager.SendEvent(_E.DATE_FINISH_YEAR, nil)
            end
        end
    end

    if self.Week:GetCurrent() == _C.CONST.SALARYWEEK then
        if math.floor(self.Day:GetCurrent()) == _C.CONST.SALARYDAY then
            LuaEventManager.SendEvent(_E.DATE_WEEK_DAY, nil, self.Year:GetCurrent(), self.Month:GetCurrent())
        end
    end

    -- print("==== Date : " .. self.Date)
    -- print("==== Day : " .. self.Day:GetCurrent())

    if ready_save == true then
        RecordController.ImmediateSave()
    end
end



return Date