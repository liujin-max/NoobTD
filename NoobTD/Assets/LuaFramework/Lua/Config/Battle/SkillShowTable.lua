--技能表现

local SkillShowTable   = {}

local ENUM  = {}

--平射
ENUM["pingshe"] =
{
    {time = 0.2, type = _C.SKILL.SHOW.BULLET, id = 10001}
}

--寒冰弹
ENUM["hanbingdan"] =
{
    {time = 0.2, type = _C.SKILL.SHOW.BULLET, id = 10001}
}








function SkillShowTable.Get(display_name)
    return ENUM[display_name]
end


return SkillShowTable