--子弹表现

local BulletTable   = {}

local ENUM  = {}

--箭矢
ENUM[10001] =
{
    id      = 10001,
    speed   = 8,
    trace   = _C.TRACE.PARABOLA,
    rotate  = _C.ROTATE.BULLET.TURNTO,
    effect  = "Prefab/Effects/Bullet/fx_bullet_10000",
    -- hit     = ""

    height  = 1,
}


function BulletTable.GetData(id)
    assert(ENUM[id], "bullet is nil : " .. tostring(id))
    return ENUM[id]
end


return BulletTable