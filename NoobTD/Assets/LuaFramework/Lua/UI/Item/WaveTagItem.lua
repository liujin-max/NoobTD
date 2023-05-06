local WaveTagItem = {}

function WaveTagItem:Awake(items)
    self.GO         = items["This"]
    self.Progress   = items["Progress"]


    UIEventListener.PGet(self.GO,   self).onClick_P = function()
        LuaEventManager.SendEvent(_E.BATTLE_WP_TOUCH, nil, self.Wave)
    end
end

function WaveTagItem:Init(wave)
    self.Wave   = wave

    self:FlushUI()
end

function WaveTagItem:FlushUI()
    self.Progress.fillAmount    = self.Wave.Timer:GetProgress()

end

function WaveTagItem:Update()
    self:FlushUI()
end



function WaveTagItem:OnDestroy()

end


return WaveTagItem