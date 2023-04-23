--开发、销售过程中的意外事件

local Accident = Class.define("Data.Accident")



function Accident:SyncMSG(msg)
    if msg.MediaRecommend ~= nil then
        self.MediaRecommend = Class.new(Logic.CDTimer, msg.MediaRecommend.Total)
        self.MediaRecommend:SetCurrent(msg.MediaRecommend.Current)
    end

    if msg.MediaHot ~= nil then
        self.MediaHot   = msg.MediaHot
    end
end

function Accident:ctor(game)
    self.Game       = game

    --被媒体推荐的概率
    self.MediaRecommend = nil
    self.MediaHot       = nil
end

--开始开发
function Accident:OnBuildingStart()
    
end

--开始销售
function Accident:OnReleaseStart()
    local fetter    = self.Game.Fetter

    --@TODO 2022-05-12 21:30:16 高评分才会被推荐
    local media_rate    = 0
    local media_hot     = 0
    if fetter.ID == _C.FETTER.MIRACLE then
        media_rate      = media_rate + 80
        media_hot       = Utility.Random.Range(35,55) / 100.0
    elseif fetter.ID == _C.FETTER.EXCELLENT then
        media_rate      = media_rate + 60
        media_hot       = Utility.Random.Range(30,45) / 100.0
    elseif fetter.ID == _C.FETTER.GOOD then
        media_rate      = media_rate + 25
        media_hot       = Utility.Random.Range(20,35) / 100.0
    end

    if Utility.Random.IsHit(media_rate) then
        self.MediaRecommend = Class.new(Logic.CDTimer, Utility.Random.Range(1, _C.CONST.WEEKSECOND * 4))
        self.MediaHot       = media_hot
        print("测试输出 推荐： " .. self.MediaRecommend:GetTotal() .. ", " .. media_hot)
    end

    
    --读者来信的概率
end

function Accident:Update(delta_time)
    
    if self.MediaRecommend ~= nil then
        self.MediaRecommend:Update(delta_time)
        if self.MediaRecommend:IsFinished() then
            --粉丝增长
            -- Controller.Data.Fans():
            --游戏热度提高
            local hot = self.MediaHot or 0
            if hot ~= 0 then
                self.Game:SetTopicHeat(round(self.Game:GetTopicHead() * (1 + hot)))
                Controller.System.Popup("由于媒体推荐，游戏热度上升了：" .. hot * 100 .. "%", function ()
                    return true
                end, nil, true) 
            end

            self.MediaRecommend = nil
            self.MediaHot       = nil
        end
    end

end

return Accident