local EventEffect = Class.define("Logic.EventEffect")

local EFFECT_LIST = {}

--触发事件 
EFFECT_LIST[1000] =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Controller.Story.Start(self.Value)
        self.Progress = 1
    end
}

--公司搬迁
EFFECT_LIST[1004] =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)

        local companys  = Controller.Data.Account():GetCompanys()
        local my_cp     = Controller.Data.Account():GetCompany()
    
        local target    = nil
        for i = 1, companys:Count() do
            local cp    = companys:Get(i)
            if cp:IsUnlock() and cp:GetPositionCount() > my_cp:GetPositionCount() then
                target  = cp
            end
        end
    
        if target ~= nil then
            Controller.System.Popup(target.MoveRes, function()
                Controller.Data.Account():ReplaceCompany(target.ID)
                return true
            end)
        end

        self.Progress = 1
    end
}

--解锁公司
EFFECT_LIST[1005] =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        local company   = Controller.Data.Account():GetCompanyByID(self.Value)
        company:Unlock()
        
        -- Controller.System.Popup("解锁公司：" .. self.Value .. "\n搬迁将花费：" .. SetShowNumber(company:GetCost()), function()
        --     Controller.Data.Account():ReplaceCompany(self.Value)
        --     return true
        -- end)

        Controller.System.Popup(company.MoveRes, function()
            Controller.Data.Account():ReplaceCompany(self.Value)
            return true
        end)

        self.Progress = 1
    end
}


--解锁招聘池
EFFECT_LIST[1007] =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        local job_centre    = Controller.Data.HR():GetJobCentre(self.Value)
        job_centre:Unlock()

        self.Progress = 1
    end
}

--获得研究点
EFFECT_LIST[1008] =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Controller.Data.Account():UpdateResearch(self.Value)

        self.Progress = 1
    end
}

--获得金钱
EFFECT_LIST[1009] =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Controller.Data.UpdateMoney(self.Value)

        self.Progress = 1
    end
}






--解锁弹球技能：#
EFFECT_LIST[2000] =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        self.Progress = 1
    end
}



--界面效果器
--打开新游制作界面
EFFECT_LIST[9000]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Logic.Navigation.GotoNewGame()

        self.Progress = 1
    end
}

--打开主机制作界面
EFFECT_LIST[9001]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Logic.Navigation.GotoNewConsole()

        self.Progress = 1
    end
}

--打开续作制作界面
EFFECT_LIST[9002]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Logic.Navigation.GotoSequelGame()

        self.Progress = 1
    end
}

--打开外包列表界面
EFFECT_LIST[9003]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Logic.Navigation.GotoOutsource()

        self.Progress = 1
    end
}




--打开员工信息界面
EFFECT_LIST[9100]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Logic.Navigation.GotoStaffInfo()

        self.Progress = 1
    end
}

--打开员工招聘界面
EFFECT_LIST[9101]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Logic.Navigation.GotoHR()

        self.Progress = 1
    end
}

--打开宣传界面
EFFECT_LIST[9200]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Logic.Navigation.GotoAdvert()

        self.Progress = 1
    end
}

--打开银行界面
EFFECT_LIST[9201]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Logic.Navigation.GotoBank()

        self.Progress = 1
    end
}

--外出打工
EFFECT_LIST[9202]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Controller.Sideline.Start()
        
        self.Progress = 1
    end
}

--打开排行界面
EFFECT_LIST[9300]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Logic.Navigation.GotoMonument()

        self.Progress = 1
    end
}

--游戏系列
EFFECT_LIST[9301]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Logic.Navigation.GotoGameSeries()

        self.Progress = 1
    end
}

--打开游戏列表界面
EFFECT_LIST[9302]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Logic.Navigation.GotoGameList()

        self.Progress = 1
    end
}

--打开发行商列表
EFFECT_LIST[9303]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Logic.Navigation.GotoAgentor()

        self.Progress = 1
    end
}



--重新开始
EFFECT_LIST[9401]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Controller.System.Popup("是否清空存档并返回主界面?", function()
            RecordController.Clear()
            Logic.GameEnter.Relogin()
        end)

        self.Progress = 1
    end
}


--退出游戏
EFFECT_LIST[9499]   =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        GameUtil.OnExitGame()

        self.Progress = 1
    end
}





EFFECT_LIST[9999999] =
{
    [_C.EVENT.TRIGGER.EXECUTE] = function(self)
        Controller.System.FlyTip("未实现的事件效果器： " .. self.ID)
        self.Progress = 1
    end
}



function EventEffect:ctor(id, value)
    self.ID         = id
    self.Value      = value
    self.Text       = Table.Get(Table.EventEffectListTable, self.ID)[2]


    self.Progress   = 0
    self.Params     = {}
    self.Executed   = false --是否执行了


    self.Entity     = EFFECT_LIST [self.ID]
    if self.Entity == nil then
        self.Entity = EFFECT_LIST[9999999]
    end
    
end

function EventEffect:Reset()
    self.Executed   = false
end

function EventEffect:IsExecutable()
    if self.Entity[_C.EVENT.TRIGGER.EXECUTABLE] ~= nil then
        return self.Entity[_C.EVENT.TRIGGER.EXECUTABLE](self)
    end

    return true
end

function EventEffect:Execute(params)
    if self.Entity[_C.EVENT.TRIGGER.EXECUTE] ~= nil then
        self.Entity[_C.EVENT.TRIGGER.EXECUTE](self, params)
    end
    self.Executed   = true
end

function EventEffect:Description()
    if self.Entity[_C.EVENT.TRIGGER.DESCRIPTION] ~= nil then
        return self.Entity[_C.EVENT.TRIGGER.DESCRIPTION](self)
    end
    return string.gsub(self.Text, "#", self.Value)
end


return EventEffect