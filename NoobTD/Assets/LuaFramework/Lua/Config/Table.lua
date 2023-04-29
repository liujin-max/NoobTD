Table = {}

Table.Empty = {}

Table.EventConditionListTable   = require("Config/EventConditionListTable")
Table.EventEffectListTable      = require("Config/EventEffectListTable")
Table.EffectListTable           = require("Config/EffectListTable")




Table.MonsterTable              = require("Config/MonsterTable")
Table.TowerTable                = require("Config/TowerTable")
Table.SkillTable                = require("Config/SkillTable")


Table.BulletTable               = require("Config/Battle/BulletTable")
Table.SkillShowTable            = require("Config/Battle/SkillShowTable")

Table.Field = {}
Table.Field[1001]               = require("Config/Battle/battle_field_1001")



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
