--EffectManager: 特效管理器
--1. 添加特效
--2. 删除特效
--3. 更新特效

local EffectManager = {}

local _list = Class.new(Array)

function EffectManager.Awake()
    _list = Class.new(Array)
    
end

function EffectManager.Add(resPath, parent,  pos)
    if pos == nil then
        pos = Vector3.zero
    end
    
    local effect = Class.new(Display.Effect, resPath, parent, pos)
    _list:Add(effect)

    return effect
end

--删除
function EffectManager.Remove(effect)
    if effect == nil then return end
    _list:Remove(effect)
    effect:Dispose()
end

return EffectManager