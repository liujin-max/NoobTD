local SceneLayer = Class.define("Logic.SceneLayer")


local bgm     = {}

function SceneLayer:ctor(tag, root)
    self.TAG        = tag
    self.Root       = root.transform
    self.FollowUI   = {}
end

function SceneLayer:Hide()
    self.Root.localPosition = Vector3.New(-3000, 0, 0)
    for tag, window in pairs(self.FollowUI) do
        window.GO.transform.anchoredPosition = Vector3.New(-3000, 0, 0)
    end
end

function SceneLayer:Show()
    self.Root.localPosition = Vector3.zero
    for tag, window in pairs(self.FollowUI) do
        window.GO.transform.anchoredPosition = Vector3.zero
    end

    if bgm[self.TAG] ~= nil then
        Logic.MusicPlayer.PlayMusic(bgm[self.TAG]) 
    end
end

function SceneLayer:UnAttachAllUI()
    self.FollowUI = {}
end

function SceneLayer:Attach(entity)
    Utility.Transform.AddTo(entity, self.Root)
end

return SceneLayer