Table = {}

Table.Empty = {}

Table.EventConditionListTable   = require("Config/EventConditionListTable")
Table.EventEffectListTable      = require("Config/EventEffectListTable")
Table.EffectListTable           = require("Config/EffectListTable")

Table.CompanyTable              = require("Config/CompanyTable")
Table.GameTypeTable             = require("Config/GameTypeTable")
Table.GameThemeTable            = require("Config/GameThemeTable")
Table.StaffTable                = require("Config/StaffTable")
Table.FitterTable               = require("Config/FitterTable")
Table.GameConsoleTable          = require("Config/GameConsoleTable")
Table.JobCentreTable            = require("Config/JobCentreTable")
Table.TrainTable                = require("Config/TrainTable")
Table.JobTable                  = require("Config/JobTable")
Table.AchievementTable          = require("Config/AchievementTable")
Table.StoryEventTable           = require("Config/StoryEventTable")
Table.AdvertTable               = require("Config/AdvertTable")
Table.FunctionsTable            = require("Config/FunctionsTable")
Table.CPUTable                  = require("Config/CPUTable")
Table.GPUTable                  = require("Config/GPUTable")
Table.RAMTable                  = require("Config/RAMTable")
Table.BankTable                 = require("Config/BankTable")
Table.UpgradeLevelTable         = require("Config/UpgradeLevelTable")
Table.AgentTable                = require("Config/AgentTable")
Table.OutsourceTable            = require("Config/OutsourceTable")
Table.SkillTable                = require("Config/SkillTable")
Table.BubbleTable               = require("Config/BubbleTable")



Table.MenuTable                 = require("Config/MenuTable")
Table.MenuOptionTable           = require("Config/MenuOptionTable")





function Table.Get(t, id)
    if t[id] == nil then
        for tname , tvalue in pairs(Table) do
            if tvalue == t then
                error("Table Key Not Found: " .. id .. " " ..  tname .. " " ..tostring(tvalue))
            end
        end
    end
    return t[id]
end

function Table.Each(t, func)
    for k, v in pairs(t) do
        func(v)
    end
end
