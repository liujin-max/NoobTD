Utility = {}

Utility.Random    = require("Utility.RandomUtility")
Utility.Transform = require("Utility.TransformUtility")

Utility.GetEmptyTable = function()
    return {}
end


Utility.GC = function()
    collectgarbage("collect")
    AssetManager:Recycle()
end

function clone( object )
    local lookup_table = {}
    local function copyObj( object )
        if type( object ) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs( object ) do
            new_table[copyObj( key )] = copyObj( value )
        end
        return setmetatable( new_table, getmetatable( object ) )
    end
    return copyObj( object )
end


function PairCount(temp)
    local c = 0
    for k,v in pairs(temp) do
        c   = c + 1
    end
    return c
end


--解析Effect效果器
function ParseEffect(effects_table)
    local effs      = Crypt.DV(clone(effects_table))
    local array     = Class.new(Array)
    for _, data in ipairs(effs) do
        local eff   = Class.new(Logic.Effect, data.id, data.value)
        array:Add(eff)
    end
    return array
end

--解析EventEffect效果器
function ParseEventEffect(effects_table)
    local effs      = Crypt.DV(clone(effects_table))
    local array     = Class.new(Array)
    for _, data in ipairs(effs) do
        local eff   = Class.new(Logic.EventEffect, data.id, data.value)
        array:Add(eff)
    end
    return array
end

--解析EventCondition
function ParseConditions(effects_table)
    local array     = Class.new(Array)
    for _, data in ipairs(effects_table) do
        local eff   = Class.new(Logic.EventCondition, data.id, data.value)
        array:Add(eff)
    end
    return array
end


function math_log(x,y)
    return math.log(y) / math.log(x)
end


function random_name()
    local name = ""

    local _crabofirstName   = 
    {
        "白","毕","蔡","曹","常","车","陈","成" ,"程","池","邓","丁","范","方","樊","闫","倪","周",
        "费","冯","符","元","袁","岳","云","曾","詹","张","章","赵","郑" ,"钟","周","邹","朱","褚","庄","卓"
        ,"傅","甘","高","葛","龚","古","关","郭","韩","何" ,"贺","洪","侯","胡","华","黄","霍","姬","简","江"
        ,"姜","蒋","金","康","柯","孔","赖","郎","乐","雷" ,"黎","李","连","廉","梁","廖","林","凌","刘","柳"
        ,"龙","卢","鲁","陆","路","吕","罗","骆","马","梅" ,"孟","莫","母","穆","倪","宁","欧","区","潘","彭"
        ,"蒲","皮","齐","戚","钱","强","秦","丘","邱","饶" ,"任","沈","盛","施","石","时","史","司徒","苏","孙"
        ,"谭","汤","唐","陶","田","童","涂","王","危","韦" ,"卫","魏","温","文","翁","巫","邬","吴","伍","武"
        ,"席","夏","萧","谢","辛","邢","徐","许","薛","严" ,"颜","杨","叶","易","殷","尤","于","余","俞","虞"
    }

    local _lastName = "岚紫儿静嘉山向幻彤烟新晓玉文光靖千雁蕊枫科寄妙笑寻初槐凡霜含迎蓝之双慕琴雪技松孤雅碧洛诗亦涵闻醉访晴元绿安震火易鹏汉如秋灵夏飞半平雨腾春筠琪盼曼栩柳念斌露萍兰梅水痴荷竹冬瑶翠芹谷凌珍丹凝宛白蝶芙映怀卉冷蕾语帅芷友威问依怜恨桃傲梦若旋蓉柏听尔丝乐召波惜真琛南潇忆香青幼宇萱菡菱寒云莲天觅柔夜小冰珊沛书巧风海以从薇代"

    local first_name    = _crabofirstName[Utility.Random.Range(1, #_crabofirstName)] or "柳"

    local length        = utf8len(_lastName)
    local num           = Utility.Random.Range(1, 2)

    for i = 1, num do
        local s_name    = utf8sub(_lastName, Utility.Random.Range(1, length - 1), 1)
        first_name      = first_name .. s_name
    end
    
    local name = first_name

    return name
end