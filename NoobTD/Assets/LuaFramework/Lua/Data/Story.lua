


local Story = Class.define("Data.Story")

function Story:ctor()

    LuaEventManager.AddHandler(_E.DATE_WEEK_DAY, self.OnWeekDay,    self,   self)
end

--每个月第四周的第一天
function Story:OnWeekDay(event, year, month)
    if Controller.Data.Account():IsSalaryPay(year, month) == false then
        Controller.Data.Account():PaySalary(year, month)
    end
end

return Story