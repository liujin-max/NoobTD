local MusicPlayer = {}

local _currentTrack         = { Key = nil, Entity = nil }          --当前的CD
local _


function MusicPlayer.PlaySound(sound)
    AssetManager:LoadSync(sound.Path)
end

--普通音乐判定
function MusicPlayer.PlayMusic(sound)
    if _currentTrack.Entity ~= nil then
        destroy(_currentTrack.Entity)
    end
 
    _currentTrack.Key       = sound.Name
    _currentTrack.Entity    = AssetManager:LoadSync(sound.Path)

    MusicPlayer.Play()
end

function MusicPlayer.Play()
    if _currentTrack.Entity ~= nil then
        local comp = _currentTrack.Entity:GetComponent("BGM")
        comp:Play()
        comp = nil
    end
end

function MusicPlayer.Pause()
    if _currentTrack.Entity ~= nil then
        local comp = _currentTrack.Entity:GetComponent("BGM")
        comp:Pause()
        comp = nil
    end
end

function MusicPlayer.Resume()
    if _currentTrack.Entity ~= nil then
        local comp = _currentTrack.Entity:GetComponent("BGM")
        comp:Resume()
        comp = nil
    end
end

return MusicPlayer