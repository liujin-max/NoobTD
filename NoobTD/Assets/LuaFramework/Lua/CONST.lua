_C = {}




_C.CONST                = {}
_C.CONST.WEEKSECOND     = 7         --7秒一周



--战场数据
_C.CONST.LAND           = {}
_C.CONST.LAND.WIDTH     = 20        --战场宽度
_C.CONST.LAND.HEIGHT    = 11        --战场高度

_C.CONST.LAND.GRID      = 50        --格子尺寸


--场景
_C.SCENE_LAYER          = {}
_C.SCENE_LAYER.MAIN     = "main"
_C.SCENE_LAYER.BATTLE   = "Battle"


--@region 战斗
_C.BATTLE               = {}
--战斗结果
_C.BATTLE.RESULT        = {}
_C.BATTLE.RESULT.WIN    = "RESULT.WIN"      
_C.BATTLE.RESULT.LOSE   = "RESULT.LOSE"
--@endregion

_C.SIDE                 = {}
_C.SIDE.ATTACK          = 1     --进攻方
_C.SIDE.DEFEND          = 2     --防守方


--@region avatar
_C.AVATAR               = {}
--朝向
_C.AVATAR.FACE          = {}
_C.AVATAR.FACE.LEFT     = "FACE.LEFT"
_C.AVATAR.FACE.RIGHT    = "FACE.RIGHT"

--挂点
_C.AVATAR.PIVOT         = {}
_C.AVATAR.PIVOT.HEAD    = "Head"
_C.AVATAR.PIVOT.BODY    = "Body"
_C.AVATAR.PIVOT.ATK     = "Attack"
_C.AVATAR.PIVOT.FOOT    = "Foot"

--@endregion




--行为动作
_C.ACTION               = {}
_C.ACTION.VOID          = "ACTION.VOID"
_C.ACTION.WALK          = "ACTION.WALK"     --行走
_C.ACTION.IDLE          = "ACTION.IDLE"     --待机
_C.ACTION.CAST          = "ACTION.CAST"     --施法
_C.ACTION.DEAD          = "ACTION.DEAD"     --死亡
_C.ACTION.BORN          = "ACTION.BORN"     --诞生、绘制
_C.ACTION.REACH         = "ACTION.REACH"    --到达终点


--死亡原因
_C.DEAD                 = {}
_C.DEAD.NORMAL          = "DEAD.NORMAL"     --正常击杀死亡


--@region 技能
_C.SKILL                = {}

--作用目标
_C.SKILL.PICK           = {}
_C.SKILL.PICK.ALLY      = 1         --我方
_C.SKILL.PICK.ENEMY     = 2         --敌方

--目标筛选器
_C.SKILL.DETECT         = {}
_C.SKILL.DETECT.NORMAL  = 100       --距离终点最近的人
_C.SKILL.DETECT.RAND    = 101       --随机
_C.SKILL.DETECT.UNSLOW  = 102       --未被减速的人




--表现
_C.SKILL.SHOW           = {}
_C.SKILL.SHOW.BULLET    = "SHOW.BULLET"
_C.SKILL.SHOW.HIT       = "SHOW.HIT"


--@endregion    


--运动轨迹
_C.TRACE                = {}
_C.TRACE.POINT          = 1     --点对点
_C.TRACE.PARABOLA       = 2     --抛物线

--旋转朝向
_C.ROTATE               = {}
_C.ROTATE.BULLET        = {}
_C.ROTATE.BULLET.ZERO   = "ROTATE.BULLET.ZERO"      --无旋转
_C.ROTATE.BULLET.TURNTO = "ROTATE.BULLET.TURNTO"    --朝向目标



_C.HIT                  = {}
--打击类型
_C.HIT.TYPE             = {}
_C.HIT.TYPE.ATK         = "HIT.TYPE.ATK"
_C.HIT.TYPE.HEAL        = "HIT.TYPE.HEAL"
_C.HIT.TYPE.ARMOR       = "HIT.TYPE.ARMOR"


--@region Buff
_C.BUFF                 = {}

--buff叠加
_C.BUFF.EXTEND          = {}
_C.BUFF.EXTEND.ADD      = 1     --叠加
_C.BUFF.EXTEND.RECOVER  = 2     --覆盖
_C.BUFF.EXTEND.ONLY     = 3     --唯一

--@endregion


_C.WAVE                 = {}
_C.WAVE.STATE           = {}
_C.WAVE.STATE.SILENCE   = 1     --静默
_C.WAVE.STATE.COUNTDOWN = 2     --倒计时
_C.WAVE.STATE.SPAWN     = 3     --产出怪物
_C.WAVE.STATE.FINISH    = 4     --结束





--@region 颜色
_C.COLOR                = {}
_C.COLOR.RED            = "<#F10000>"

--@endregion    


------------------------- UI的相关变量 -------------------
_C.UI                       = {}
_C.UI.ITEM                  = {}
_C.UI.ITEM.SYSTEMTIP        = "SystemTipItem"
_C.UI.ITEM.SYSTEMPOPUP      = "SystemPopupItem"
_C.UI.ITEM.BUILD            = "BuildItem"
_C.UI.ITEM.HPBAR            = "HPBar"
_C.UI.ITEM.BUILDRING        = "BuildRingItem"
_C.UI.ITEM.WAVETAG          = "WaveTagItem"







_C.UI.WINDOW                = {}
_C.UI.WINDOW.SYSTEMPOPUP    = "SystemPopupWindow"
_C.UI.WINDOW.BATTLE         = "BattleWindow"
_C.UI.WINDOW.PAUSE          = "PauseWindow"
_C.UI.WINDOW.VICTORY        = "VictoryWindow"
_C.UI.WINDOW.LOSE           = "LoseWindow"







_C.EVENT                    = {}
_C.EVENT.TRIGGER            = {}
_C.EVENT.TRIGGER.CHECK      = "EVENT.TRIGGER.CHECK"
_C.EVENT.TRIGGER.EXECUTE    = "EVENT.TRIGGER.EXECUTE"
_C.EVENT.TRIGGER.EXECUTABLE = "EVENT.TRIGGER.EXECUTABLE"
_C.EVENT.TRIGGER.COST       = "EVENT.TRIGGER.COST"
_C.EVENT.TRIGGER.PRELOAD    = "EVENT.TRIGGER.PRELOAD"
_C.EVENT.TRIGGER.DESCRIPTION= "EVENT.TRIGGER.DESCRIPTION"

-----
_C.PHASE                    = {}
_C.PHASE.DESCRIPTION        = "PHASE.DESCRIPTION"         --描述
_C.PHASE.FILTER             = "PHASE.FILTER"
_C.PHASE.FINISH             = "PHASE.FINISH"




_C.MESSAGE                  = {}
_C.MESSAGE.COINERROR        = "金币不足"