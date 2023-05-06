--子弹表现

local BulletTable   = {}

local ENUM  = {}

--箭矢
ENUM[10001] =
{
    id      = 10001,
    speed   = 10,
    trace   = _C.TRACE.POINT,
    rotate  = _C.ROTATE.BULLET.TURNTO,
    effect  = "Prefab/Effects/Bullet/fx_bullet_10000",
    -- hit     = ""
}


function BulletTable.GetData(id)
    assert(ENUM[id], "bullet is nil : " .. tostring(id))
    return ENUM[id]
end


return BulletTable