Table = {}

Table.Empty = {}

Table.EventConditionListTable   = require("Config/EventConditionListTable")
Table.EventEffectListTable      = require("Config/EventEffectListTable")
Table.EffectListTable           = require("Config/EffectListTable")



Table.SkillTable                = require("Config/SkillTable")






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
