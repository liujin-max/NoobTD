--ClockTower:
--时钟塔
--计数模块，每1秒钟跳一次
--跳过之后, 就分发给所有的监听计数的模块
--每过一段时间N, 和服务器对接一次, 计数一次
--如果发现偏差了X
--发送给所有的系统，告诉他们产生了偏差，极为发送一个x过去
--一些重要的养成点事件, 只信任服务器发送过来的数据.

ClockTower = {}

function ClockTower.Awake()
    NoobTD.Timer.Register(1, ClockTower.Tiktok, nil, true, true)
end

function ClockTower.Tiktok()
    LuaEventManager.SendEvent(_E.SECOND_PASSED, nil, nil)
end