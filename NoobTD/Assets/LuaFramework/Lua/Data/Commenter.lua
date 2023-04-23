--生成评论
--@TODO 2022-03-21 19:13:01 慢慢填充
local Commenter = Class.define("Data.Commenter")


--@region 评论描述
local ENUM      = {}

--普通评论
--相性评论
--游戏属性评论
ENUM[0] = function(game)
    local array     = Class.new(Array)
    array:Add("毫无游戏体验")
    array:Add("五星差评!")
    array:Add("失败的搭配")
    array:Add("烂透了！")

    --最低能力
    local atr_type   = game:GetAttributeMin()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("毫无创意!!")
        array:Add("拜托多花点心思吧")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("游戏太卡了..")
        array:Add("玩着玩着就闪退了...")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("图像质量很差")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("我聋了？")
        array:Add("静音的体验更好")
    end

    --最高能力
    local atr_type   = game:GetAttributeMax()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("光有想法没有用啊")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("技术是唯一的亮点")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("画面是唯一的亮点")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("音乐是唯一的亮点")
    end

    return array
end

ENUM[1] = function(game)
    local array     = Class.new(Array)
    array:Add("毫无游戏体验")
    array:Add("五星差评!")
    array:Add("失败的搭配")
    array:Add("打起精神来！")

    --最低能力
    local atr_type   = game:GetAttributeMin()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("毫无创意!!")
        array:Add("拜托多花点心思吧")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("游戏太卡了..")
        array:Add("玩着玩着就闪退了...")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("图像质量很差")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("我聋了？")
        array:Add("静音的体验更好")
    end

    --最高能力
    local atr_type   = game:GetAttributeMax()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("光有想法没有用啊")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("技术是唯一的亮点")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("画面是唯一的亮点")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("音乐是唯一的亮点")
    end

    return array
end

ENUM[2] = function(game)
    local array     = Class.new(Array)
    array:Add("枯燥无味")
    array:Add("千万别买！")
    array:Add("这个组合不对劲")
    array:Add("好好培养员工吧")
    array:Add("打起精神来！")
    array:Add("鸡皮疙瘩掉了一地")
    array:Add("不推荐\n体验稀烂")

    local atr_type   = game:GetAttributeMin()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("毫无创意!!")
        array:Add("拜托多花点心思吧")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("找个电子厂上班吧")
        array:Add("玩着玩着就闪退了...")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("游戏画面不怎么样")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("我聋了？")
        array:Add("静音的体验更好...")
    end

    --最高能力
    local atr_type   = game:GetAttributeMax()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("光有想法没有用啊")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("技术是唯一的亮点")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("细节还行")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("用心做音乐\n用脚做游戏")
    end
    return array
end

ENUM[3] = function(game)
    local array     = Class.new(Array)
    array:Add("有点无聊")
    array:Add("不建议购买")
    array:Add("好好培养员工吧")
    array:Add("不可能有人玩通关")
    array:Add("刚买来就吃灰了")
    array:Add("找个电子厂上班吧")
    array:Add("应该申请退款...")
    array:Add("3分不能再多了")

    local atr_type   = game:GetAttributeMin()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("鸡皮疙瘩掉了一地")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("我上我也行")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("贵公司没有美术员工吗？")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("音质太差了")
    end


    local atr_type   = game:GetAttributeMax()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("高手在民间")
        array:Add("玩法上有所创新")
        
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("高手在民间")
        array:Add("玩法上有所创新")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("建议美术单飞")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("用心做音乐\n用脚做游戏")
    end
    return array
end

ENUM[4] = function(game)
    local array     = Class.new(Array)
    array:Add("吸取教训\n慢慢进步")
    array:Add("有待进步")
    array:Add("只能算半成品吧")
    array:Add("中规中矩")
    array:Add("好好培养员工吧")

    local atr_type   = game:GetAttributeMin()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("没什么创意")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("优化不太好")
        array:Add("买bug\n送游戏")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("画面太差了")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("好好改进一下游戏的音乐吧")
    end


    local atr_type   = game:GetAttributeMax()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("心有余而力不足")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("心有余而力不足")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("建议美术单飞")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("内容有点少")
    end
    return array
end

ENUM[5] = function(game)
    local array     = Class.new(Array)
    array:Add("普普通通\n没有亮点")
    array:Add("还凑合吧")
    array:Add("简单易上手")
    array:Add("中规中矩")
    array:Add("很有发展潜力")
    array:Add("挺上头的")

    local atr_type   = game:GetAttributeMin()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("趣味性不足")
        array:Add("玩法不太行")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("Bug多到数不清")
        array:Add("玩法不太行")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("画面有待提高")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("贵公司没有音乐员工吗？")
    end


    local atr_type   = game:GetAttributeMax()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("异于常人的想法")
        array:Add("剧情演绎很不错")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("没有感情全是技巧")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("应该会有人喜欢吧")
    end
    return array
end

ENUM[6] = function(game)
    local array     = Class.new(Array)
    array:Add("看得出来比较用心")
    array:Add("不如那啥~")
    array:Add("简单易上手")
    array:Add("再接再厉吧")
    array:Add("很有发展潜力")
    array:Add("有点上瘾")

    local atr_type   = game:GetAttributeMin()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("想法有点老套")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("嗯..欠缺技术")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("画面有待提高")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("音质有待提高")
    end

    local atr_type   = game:GetAttributeMax()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("想法不错很有趣")
        array:Add("主线很丰富")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("没有感情全是技巧")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("应该会有人喜欢吧")
    end
    return array
end

ENUM[7] = function(game)
    local array     = Class.new(Array)
    array:Add("完全出乎意料")
    array:Add("有趣的体验")
    array:Add("快点更新\n快点更新")
    array:Add("支持一下")
    array:Add("给个好评")
    array:Add("再玩一把就睡觉")

    local atr_type   = game:GetAttributeMin()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("难度有点高...")
        array:Add("流程太短\n不够尽兴")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("精细度差点意思")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("需要更亮眼的设计")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then

    end


    local atr_type   = game:GetAttributeMax()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("很有创意\n玩的停不下来")
        array:Add("主线很丰富")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("推荐购买")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("爱死这个画风了")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("被游戏耽误了的音乐公司")
        array:Add("很棒，尤其是这个配音")
        array:Add("音乐令人印象深刻")
    end

    return array
end

ENUM[8] = function(game)
    local array     = Class.new(Array)
    array:Add("销量一定很好吧")
    array:Add("好玩到停不下来")
    array:Add("连续玩了三天三夜...")
    array:Add("终于等到这一天！")
    array:Add("怒给好评！")
    array:Add("如丝般顺滑的体验")
    array:Add("对新手玩家非常友好")


    local game_type     = game.Type
    array:Add(string.format("最优秀的%s游戏之一", game_type.Name))


    local atr_type   = game:GetAttributeMin()
    if atr_type == _C.ATTRIBUTE.PLAN then
        
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("可以在游戏性上做的更好")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("改进一下画面吧\n办法总比困难多！")
        array:Add("画质是唯一美中不足的地方")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("音效是唯一美中不足的地方")
    end


    local atr_type   = game:GetAttributeMax()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("游戏很有趣\n会一直玩下去")
        array:Add("游戏体验很好")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("回过神来已经天亮了")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("十年做游戏\n九年做CG")
        array:Add("爱死这个画风了")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("很棒，尤其是这个配音")
        array:Add("音乐令人印象深刻")
    end

    return array
end

ENUM[9] = function(game)
    local array     = Class.new(Array)
    array:Add("呆在家里慢慢玩")
    array:Add("太完美了！")
    array:Add("距离完美只差一点")
    array:Add("打开游戏的那一刻泪流满面TOT")
    array:Add("作为生日礼物送了女友一套...")
    array:Add("游戏体验很好")

    if game:IsNetwork() == false then
        array:Add("期待续作！")
    end

    local game_type     = game.Type
    array:Add(string.format("最优秀的%s游戏之一", game_type.Name))


    local atr_type   = game:GetAttributeMin()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("距离完美只差一点点创意了")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then

    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("画质是唯一美中不足的地方")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then

    end


    local atr_type   = game:GetAttributeMax()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("现象级的产品")
        array:Add("游戏体验很好")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("一家三口都在玩！！")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("罗马不是一天建成的")
        array:Add("十年做游戏\n九年做CG")
        array:Add("爱死这个画风了")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("年度最佳游戏歌曲")
        if game:IsSequel() == true then
            array:Add("这熟悉的主旋律...泪目了")
        end
    end

    return array
end

ENUM[10] = function(game)
    local array     = Class.new(Array)
    array:Add("废寝忘食玩了一整天~")
    array:Add("太完美了！！")
    array:Add("跌向神坛的杰作！")
    array:Add("你才是世界的主宰！！！")
    array:Add("年度最佳！！！")

    if game:IsNetwork() == false then
        array:Add("期待续作！")
    end
    
    local game_type     = game.Type
    array:Add(string.format("迄今为止体验最好的%s作品", game_type.Name))

    local atr_type   = game:GetAttributeMax()
    if atr_type == _C.ATTRIBUTE.PLAN then
        array:Add("现象级的产品")
        array:Add("游戏体验很好")
    elseif atr_type == _C.ATTRIBUTE.PROGRAM then
        array:Add("单独再买了一套作为收藏")
    elseif atr_type == _C.ATTRIBUTE.ARTS then
        array:Add("完美的艺术品！")
        array:Add("罗马不是一天建成的")
        array:Add("爱死这个画风了")
    elseif atr_type == _C.ATTRIBUTE.MUSIC then
        array:Add("跪求OST！！！")
        array:Add("年度最佳游戏歌曲")
        if game:IsSequel() == true then
            array:Add("这熟悉的主旋律...泪目了")
        end
    end

    return array
end

--@endregion

--@region 相性评论
local FETTER    = {}

FETTER[_C.FETTER.RANGE]     = function(game)
    local game_type     = game.Type
    local game_theme    = game.Theme

    local array         = Class.new(Array)
    array:Add(string.format("%s和%s实在是太失败了", game_type.Name, game_theme.Name))

    return array
end

FETTER[_C.FETTER.BAD]       = function(game)
    local game_type     = game.Type
    local game_theme    = game.Theme

    local array         = Class.new(Array)
    array:Add(string.format("%s和%s的内容有点奇怪", game_type.Name, game_theme.Name))

    return array
end

FETTER[_C.FETTER.NORMAL]    = function(game)
    local game_type     = game.Type
    local game_theme    = game.Theme

    local array         = Class.new(Array)


    return array
end

FETTER[_C.FETTER.GOOD]      = function(game)
    local game_type     = game.Type
    local game_theme    = game.Theme

    local array         = Class.new(Array)
    array:Add(string.format("这个组合很有趣", game_theme.Name, game_type.Name))

    return array
end

FETTER[_C.FETTER.EXCELLENT] = function(game)
    local game_type     = game.Type
    local game_theme    = game.Theme

    local array         = Class.new(Array)
    array:Add(string.format("%s搭配%s真是极好的！", game_type.Name, game_theme.Name))

    return array
end

FETTER[_C.FETTER.MIRACLE] = function(game)
    local game_type     = game.Type
    local game_theme    = game.Theme

    local array         = Class.new(Array)
    array:Add("奇迹般的组合！！！")

    return array
end
--@endregion

--@region 游戏类型
local TYPE          = {}

TYPE[_C.GAME.TYPE.XIUXIAN] = function(game)
    local array     = Class.new(Array)

    array:Add("游戏很休闲\n闲暇时可以玩玩")

    return array
end

TYPE[_C.GAME.TYPE.YANNGCHENG] = function(game)
    local game_theme    = game.Theme

    local evaluator     = game.Evaluator
    local avg_score     = evaluator:GetAvgScore()

    local array     = Class.new(Array)

    if game_theme == _C.GAME.THEME.LIANAIRPG then
        if avg_score >= 8 then
            array:Add("不知道创造它的人初衷是什么\n但一定是个内心温暖的人")
        end
    end

    return array
end

--@endregion


function Commenter.Filter(game, evaluator, score)
    local fetter    = game.Fetter
    local type      = game.Type

    local array     = Class.new(Array)

    local temp      = ENUM[score](game)
    temp:Each(function(text)
        array:Add(text)
    end)

    local fetter_func   = FETTER[fetter.ID]
    if fetter_func ~= nil then
        local temp      = fetter_func(game)
        temp:Each(function(text)
            array:Add(text)
        end)
    end

    local type_func = TYPE[type.ID]
    if type_func ~= nil then
        local temp      = type_func(game)
        temp:Each(function(text)
            array:Add(text)
        end)
    end

    local picked    = Utility.Random.Pick(1,array,function(des)
        for k,v in pairs(evaluator.Comments) do
            if des == v then
                return false
            end
        end
        return true
    end)

    return picked:First()
end


local MSG   = {}
MSG[0]      = function(game)
    local array     = Class.new(Array)

    return array
end




































function Commenter.PickOne(game)
    local avg_score = game.Evaluator:GetAvgScore()

    local array     = Class.new(Array)
    
    array:Add({Emoji = Display.EMOJI.KUJIJI ,       Msg = "给个发售日期呀！"} )
    array:Add({Emoji = Display.EMOJI.JINGYA ,       Msg = "是我喜欢的类型"})
    array:Add({Emoji = Display.EMOJI.JINGYA ,       Msg = "我的天啊！"})
    array:Add({Emoji = Display.EMOJI.ZUICHAN ,      Msg = "现在就想玩！"})
    array:Add({Emoji = Display.EMOJI.JINGYA ,       Msg = "什么时候能玩？！"} )
    array:Add({Emoji = Display.EMOJI.ZIYAXIAO ,     Msg = "可别跳票了！"}  )
    array:Add({Emoji = Display.EMOJI.AIXINYAN ,     Msg = "什么时候上线？"} )
    array:Add({Emoji = Display.EMOJI.ZUICHAN ,      Msg = "快把游戏做完！"})
    array:Add({Emoji = Display.EMOJI.KUJIJI ,       Msg = "为什么要做这么久？"})
    array:Add({Emoji = Display.EMOJI.LOUYA ,        Msg = "你磨蹭啥呢"})
    array:Add({Emoji = Display.EMOJI.KEAI ,         Msg = "冲啊"} )
    array:Add({Emoji = Display.EMOJI.SHENGQI ,      Msg = "敢跳票我就给差评"} )
    array:Add({Emoji = Display.EMOJI.NANGUO ,       Msg = "和想象中的不太一样"} )
    array:Add({Emoji = Display.EMOJI.KUJIJI ,       Msg = "我有个朋友临走前想..."} )
    array:Add({Emoji = Display.EMOJI.COOL ,         Msg = ""} )
    array:Add({Emoji = Display.EMOJI.PAICHI ,       Msg = ""} )
    array:Add({Emoji = Display.EMOJI.BIZUI ,        Msg = "好玩吗？"})
    array:Add({Emoji = Display.EMOJI.KUJIJI ,       Msg = "价格是多少呢"} )
    array:Add({Emoji = Display.EMOJI.WEIXIAO ,      Msg = "还可以"} )
    array:Add({Emoji = Display.EMOJI.SHENGQI ,      Msg = "快点出啊！"} )
    array:Add({Emoji = Display.EMOJI.WEIXIAO ,      Msg = "试玩版还不错"} )
    array:Add({Emoji = Display.EMOJI.QINWEN ,       Msg = "期待！"} )
    array:Add({Emoji = Display.EMOJI.JINGYA ,       Msg = "感觉挺有意思！"} )
    array:Add({Emoji = Display.EMOJI.JINGYA ,       Msg = "就决定是你了！"} )
    array:Add({Emoji = Display.EMOJI.LOUYA ,        Msg = "希望是免费的"} )
    array:Add({Emoji = Display.EMOJI.WEIXIAO ,      Msg = "坐等发售"} )
    array:Add({Emoji = Display.EMOJI.JINGYA ,       Msg = "画面真的不错"} )
    array:Add({Emoji = Display.EMOJI.WEIXIAO ,      Msg = "不错不错"} )
    array:Add({Emoji = Display.EMOJI.BIZUI ,        Msg = "挽尊"} )
    array:Add({Emoji = Display.EMOJI.WEIXIAO ,      Msg = "开始预售了吗"} )
    array:Add({Emoji = Display.EMOJI.AIXINYAN ,     Msg = "爱了爱了"} )
    array:Add({Emoji = Display.EMOJI.KEAI ,         Msg = "非常感谢"} )
    array:Add({Emoji = Display.EMOJI.LOUYA ,        Msg = "我想白嫖"} )
    array:Add({Emoji = Display.EMOJI.ZUICHAN ,      Msg = "希望打折"} )
    array:Add({Emoji = Display.EMOJI.KUJIJI ,       Msg = "谁给我买个吧"} )
    array:Add({Emoji = Display.EMOJI.LEILIUMANMIAN ,Msg = "我一点都不想玩"} )
    array:Add({Emoji = Display.EMOJI.BIZUI ,        Msg = "希望不要跳票"} )
    array:Add({Emoji = Display.EMOJI.COOL ,         Msg = "快出！买爆！"} )
    array:Add({Emoji = Display.EMOJI.ZIYAXIAO ,     Msg = "真香警告"} )
    array:Add({Emoji = Display.EMOJI.ZUICHAN ,      Msg = "可以联机吗？"} )
    array:Add({Emoji = Display.EMOJI.JINGYA ,       Msg = "能和朋友一起玩吗？"} )


    array:Add({Msg = "挺有意思的"} )
    array:Add({Msg = "够爽快！！"} )
    array:Add({Msg = "有点想玩"} )
    array:Add({Msg = "第一眼看着还可以"} )
    array:Add({Msg = "支持一下国货"} )
    array:Add({Msg = "希望可以便宜点"} )
    array:Add({Msg = "在哪里才能玩得到呢"} )
    array:Add({Msg = "多久出？"} )
    array:Add({Msg = "哪里可以试玩？"} )
    array:Add({Msg = "早点发售啊"} )
    array:Add({Msg = "提不起兴趣"} )
    array:Add({Msg = "有点失望"} )
    array:Add({Msg = "画风不是我的菜"} )
    array:Add({Msg = "对这个类型提不起兴趣~"} )
    array:Add({Msg = "还没玩过"} )
    array:Add({Msg = "内容有点少"} )
    array:Add({Msg = "想试试"} )
    array:Add({Msg = "看着还行"} )
    array:Add({Msg = "坐等"} )
    array:Add({Msg = "有内味儿了~"} )
    array:Add({Msg = "值得期待吗？"} )
    array:Add({Msg = "啊吧啊吧"} )
    array:Add({Msg = "看过直播"} )
    array:Add({Msg = "啊这..."} )
    array:Add({Msg = "等发售"} )
    array:Add({Msg = "就等发售了"} )
    array:Add({Msg = "种草"} )
    array:Add({Msg = "兴奋，紧张，高兴"} )
    array:Add({Msg = "可以下载吗？"} )
    array:Add({Msg = "那必须要得"} )
    array:Add({Msg = "很期待！！"} )
    array:Add({Msg = "呵呵呵呵"} )
    array:Add({Msg = "耶耶耶"} )
    array:Add({Msg = "这个题材很难得"} )
    array:Add({Msg = "快点，快点，再快点！"} )
    array:Add({Msg = "啥也不说了"} )
    array:Add({Msg = "关注了"} )
    array:Add({Msg = "关注"} )
    array:Add({Msg = "没玩过想玩玩"} )
    array:Add({Msg = "路过"} )
    array:Add({Msg = "飘过"} )
    array:Add({Msg = "买它"} )
    array:Add({Msg = "送我一份吧"} )
    array:Add({Msg = "哦呦"} )
    -- array:Add({Msg = "(*๓´╰╯`๓)"} )
    

    --@region 评分相关
    if avg_score >= 4 then
        array:Add({Emoji = Display.EMOJI.AIXINYAN ,     Msg = "呆在我的愿望单好久了"} )
        array:Add({Emoji = Display.EMOJI.AIXINYAN ,     Msg = "美术很喜欢！"} )
        array:Add({Emoji = Display.EMOJI.ZUICHAN ,      Msg = "画风真的很讨喜！"} )
        array:Add({Emoji = Display.EMOJI.KEAI ,         Msg = "这个月就等这个了。"} )

        array:Add({Msg = "想玩"} )
        array:Add({Msg = "这个应该不错的"} )
        array:Add({Msg = "不错"} )
    end

    if avg_score >= 6 then
        array:Add({Emoji = Display.EMOJI.AIXINYAN ,     Msg = "很好玩的样子"})
        array:Add({Emoji = Display.EMOJI.KEAI ,         Msg = "迫不及待了！"})
        array:Add({Emoji = Display.EMOJI.COOL ,         Msg = "牛皮666"} )

        array:Add({Msg = "很有创意"} )
        array:Add({Msg = "这个确实可以"} )
        array:Add({Msg = "出了必买！"} )
        array:Add({Msg = "不容错过"} )
        array:Add({Msg = "值得！！"} )
    end

    if avg_score >= 8 then
        array:Add({Emoji = Display.EMOJI.JINGYA ,       Msg = "国产之光"})
        array:Add({Emoji = Display.EMOJI.JINGYA ,       Msg = "年度最佳！"})
        array:Add({Emoji = Display.EMOJI.WEIXIAO ,      Msg = "这才是游戏该有的样子！"})
        array:Add({Emoji = Display.EMOJI.AIXINYAN ,     Msg = "五星好评！"})
        array:Add({Emoji = Display.EMOJI.ZUICHAN ,      Msg = "必须得玩的游戏"})

        array:Add({Msg = "懂的都懂"})
    end


    if avg_score <= 3 then
        array:Add({Emoji = Display.EMOJI.BIZUI ,        Msg = "无聊~"} )
        array:Add({Emoji = Display.EMOJI.PAICHI ,       Msg = "没意思..."} )
        array:Add({Emoji = Display.EMOJI.LVPAICHI ,     Msg = "看起来很无聊"} )
        array:Add({Emoji = Display.EMOJI.TULE ,         Msg = "别买"} )

        array:Add({Msg = "内容太少了"} )
        array:Add({Msg = "老掉牙的故事"} )
        array:Add({Msg = "什么鬼啊"} )
    end

    if avg_score <= 5 then
        array:Add({Emoji = Display.EMOJI.TULE ,         Msg = "实在不怎么样"} )
        array:Add({Emoji = Display.EMOJI.NANGUO ,       Msg = "没啥亮点~"} )
        array:Add({Emoji = Display.EMOJI.LIUHANXIAO ,   Msg = "不好玩的样子"})
        array:Add({Emoji = Display.EMOJI.BIZUI ,        Msg = "徒有其表"})
        array:Add({Emoji = Display.EMOJI.BIZUI ,        Msg = "潜力被浪费了"})
        array:Add({Emoji = Display.EMOJI.SHENGQI ,      Msg = "潜力被浪费了"})
        array:Add({Emoji = Display.EMOJI.NANGUO ,       Msg = "不吸引人"} )

        array:Add({Msg = "再观望观望"} )    
        array:Add({Msg = "一般般吧"} )
        array:Add({Msg = "平庸之作"} )
    end
    
    --@endregion


    --@region 游戏类型
    if game.Type.ID == _C.GAME.TYPE.SHEJI or game.Type.ID == _C.GAME.TYPE.DONGSHEJI then
        array:Add({Msg = "就爱突突突"} )
    end
    --@endregion

    --续作
    if game:IsSequel() == true then
        array:Add({Emoji = Display.EMOJI.ZUICHAN ,      Msg = "经典之作"} )
        array:Add({Emoji = Display.EMOJI.AIXINYAN ,     Msg = "经典永不过时"} )
        array:Add({Emoji = Display.EMOJI.AIXINYAN ,     Msg = "最期待的游戏之一"} )
        array:Add({Emoji = Display.EMOJI.KEAI ,         Msg = "希望比上一代好玩"} )

        array:Add({Msg = "这个系列都不错"} )
        array:Add({Msg = "经典系列"} )
        array:Add({Msg = "玩过前作"} )
        array:Add({Msg = "童年回忆"} )

        

    end

    return Utility.Random.PickOne(array)
end


return Commenter