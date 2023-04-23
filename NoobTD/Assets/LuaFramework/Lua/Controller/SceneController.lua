--场景切换使用, 比如战斗/挂机, 战斗A/战斗B等等

local SceneController = {}

local P = {}

function SceneController.Start()
    local main_layer        = GameObject.Find("MAIN")
    local factory_layer     = GameObject.Find("FACTORY")

    P.Layer = {}
    P.Layer[_C.SCENE_LAYER.MAIN]    = Class.new(Logic.SceneLayer, _C.SCENE_LAYER.MAIN,       main_layer)
    P.Layer[_C.SCENE_LAYER.BATTLE]  = Class.new(Logic.SceneLayer, _C.SCENE_LAYER.BATTLE,    factory_layer)

    P.CurrentTag = _C.SCENE_LAYER.MAIN
end

function SceneController.GetCurrentTag()
    return P.CurrentTag
end

function SceneController.SwitchTo(scene_tag)
    P.Layer[P.CurrentTag]:Hide()
    P.Layer[scene_tag]:Show()
    P.CurrentTag = scene_tag
end

function SceneController.AttachUI(scene_tag, ui_window_tag)
    P.Layer[scene_tag].FollowUI[ui_window_tag] = UI[ui_window_tag]
end

function SceneController.Attach(scene_tag, entity)
    P.Layer[scene_tag]:Attach(entity)
end

function SceneController.GetLayer(scene_tag)
    return P.Layer[scene_tag]
end

function SceneController.ClearLayer(scene_tag)
    P.Layer[scene_tag]:UnAttachAllUI()
end

function SceneController.Dispose()

end

return SceneController